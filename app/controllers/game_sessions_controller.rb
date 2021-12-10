class GameSessionsController < ApplicationController
  def start_game
    @game_session = current_user.only_open_session
    redirect_to root_path, alert: "Something went wrong..." if @game_session.nil?

    @img_start_url, @img_end_url = request_wiki_images(
      [@game_session.game.start_url, @game_session.game.end_url]
    )
    @html_game = get_wiki_article(@game_session.game.start_url)
    @game_session.update({ started_at: Time.now, status: 1 })

    render :play
  end

  def play
    @game_session = GameSession.includes(:game).find_by({ user: current_user,
                                                          status: 1 })
    @game_session.path << params[:article]
    @game_session.clicks += 1
    @game_session.save

    if params[:article] == @game_session.game.end_url
      @game_session.update(ended_at: Time.now)
      @game_session.update(score: @game_session.calculate_final_score,
                           status: 2)
      html_message = render_to_string(partial: 'game_sessions/modal_win', locals: { game_session: @game_session })
      html_scores = render_to_string(partial: 'game_sessions/modal_score', locals: { all_sessions: @game_session.sibling_game_sessions.order(:score).reverse })
      cable_ready[PlayChannel]
        .inner_html(selector: "#score-all-modal", html: html_scores)
        .dispatch_event(name: 'win:lobby')
        .broadcast_to(@game_session.lobby)
      render operations: cable_car
        .inner_html('#score-modal', html: html_message)
        .dispatch_event(name: 'win:game')
    else
      html_game = get_wiki_article(params[:article])
      render operations: cable_car
        .text_content('#user-counter', text: @game_session.clicks.to_s)
        .inner_html('#game-page', html: html_game)
        .dispatch_event(name: 'article:refresh')
    end
  end

  private

  def get_wiki_article(url)
    # TODO, add geolocation to modify behaviour for different wikipedia languages
    url = "https://en.wikipedia.org/wiki/#{url}"
    html_file = request_wiki(url)
    html_doc = Nokogiri::HTML(html_file)

    # Display only article
    html_doc = html_doc.search('#content')
    # Remove references list and category links
    html_doc.search('div.reflist', '#catlinks', '.printfooter').remove
    # Add back button

    html_doc.search('a').map do |link|
      next unless link.attributes.include?('href')

      href = link[:href]
      # Exclude href's that link to own page (#), link to external pages and link to Wikipedia resources
      if href.include?(':') || href.include?('#') || !href.starts_with?('/wiki/')
        link.remove_attribute('href')
        link['data-bs-toggle'] = 'tooltip'
        link['data-bs-placement'] = 'top'
        link['title'] = "These aren't the links you're looking for..."
      else
        href = href.split('/').last
        link['data-remote'] = "true"
        link['data-action'] = "play-article#loading"
        link[:href] = "/game_session/#{@game_session.id}/#{href}"
      end
    end
    return html_doc.to_s.html_safe
  end

  def request_wiki(url)
    request = Typhoeus::Request.new(url, followlocation: true)
    request.on_complete do |response|
      if response.success?
        return response.body
      elsif response.timed_out?
        log("got a time out")
      elsif response.code == 0
        # Could not get an http response, something's wrong.
        log(response.return_message)
      else
        # Received a non-successful http response.
        log("HTTP request failed: " + response.code.to_s)
      end
    end
    request.run
  end

  def request_wiki_images(options)
    hydra = Typhoeus::Hydra.new
    requests = options.map do |option|
      request = Typhoeus::Request.new("https://en.wikipedia.org/w/api.php?action=query&titles=#{option}&prop=pageimages&format=json&pithumbsize=100", followlocation: true)
      hydra.queue(request)
      request
    end
    hydra.run
    requests.map do |request|
      json = JSON.parse(request.response.body)
      begin
        json['query']['pages'].values[0]['thumbnail']['source']
      rescue
        "https://img.favpng.com/25/6/12/question-mark-computer-icons-button-png-favpng-pxSnEqGEqwH1zKRAbd60X41gX.jpg"
      end
    end
  end
end
