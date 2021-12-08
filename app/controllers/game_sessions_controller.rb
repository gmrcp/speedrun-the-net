require 'open-uri'

class GameSessionsController < ApplicationController
  include CableReady::Broadcaster

  def start_game
    @game_session = GameSession.includes(:game).find_by(
      {
        user: current_user,
        status: 0
      }
    )
    if params[:start_url] && params[:end_url]
      params.permit(:start_url, :end_url)
      @game_session.game.update(
        {
          start_url: params[:start_url],
          end_url: params[:end_url]
        }
      )
      @game_session.update(
        {
          started_at: Time.now,
          status: 1
        }
      )
      @img_start_url = get_image_wiki(@game_session.game.start_url)
      @img_end_url =   get_image_wiki(@game_session.game.end_url)
      @html_game =     format_wiki_article(@game_session.game.start_url)

      render :play
    else
      redirect_to lobby_path(code: @game_session.lobby.code), alert: "That didn't work... Try again!"
    end
  end

  def play
    @game_session = GameSession.includes(:game).find_by({ user: current_user,
                                                          status: 1 })
    if params[:article] == @game_session.game.end_url
      @game_session.ended_at = Time.now
      @game_session.save
      html = render_to_string(partial: 'shared/modal_win', locals: { game_session: @game_session })
      render operations: cable_car
        .inner_html('#score-modal', html: html)
        .dispatch_event(name: 'win:game')
    else
      html_game = wiki
      render operations: cable_car
        .text_content('#user-counter', text: @game_session.clicks.to_s)
        .inner_html('#game-page', html: html_game)
        .dispatch_event(name: 'article:refresh')
    end
  end

  private

  def wiki
    # TODO, array to confirm link clicked is present in previous page
    @game_session.path << params[:article]
    @game_session.clicks += 1
    @game_session.save

    # Modify Back button
    # render operations: cable_car
    #     .text_content('#back-button', text: @game_session.clicks.count.to_s)
    #     .inner_html('#game-page', html: html_game)
    #     .dispatch_event(name: 'article:refresh')


    # Check win condition

    return format_wiki_article(params[:article])
  end

  def get_image_wiki(option)
    url = "https://en.wikipedia.org/w/api.php?action=query&titles=#{option}&prop=pageimages&format=json&pithumbsize=100"
    html = URI.parse(url).open
    json = JSON.parse(html.read)
    begin
      return json['query']['pages'].values[0]['thumbnail']['source']
    rescue
      return "https://via.placeholder.com/80"
    end
  end

  def format_wiki_article(url)
    # TODO, add geolocation to modify behaviour for different wikipedia languages
    url = "https://en.wikipedia.org/wiki/#{url}"
    html_file = URI.parse(url).open
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
end
