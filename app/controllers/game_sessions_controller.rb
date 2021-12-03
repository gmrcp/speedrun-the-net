require 'open-uri'

class GameSessionsController < ApplicationController
  def create
  end

  def start_game
    @game_session = GameSession.create!({
      user: current_user,
      game: Game.first,
      started_at: Time.now
    })
    redirect_to play_path(@game_session, @game_session.game.start_url)
  end

  def play
    @game_session = GameSession.find(params[:id])
    if @game_session.game.category == 'default'
      wiki
    end
  end

  def update
  end

  private

  def wiki
    # TODO, certify that game_session is related to user (be it guest or logged user) -> Devise?
    # TODO, array to confirm link clicked is present in previous page
    # i.e. user_session.present_links.include?('params[:article]')
    # TODO, store clicks in array BUT structured -> JSON (array of hashs with arrays...)

    # Check if round just started
    unless params[:article] == @game_session.game.start_url &&
                               @game_session.clicks.empty?
      @game_session.clicks << params[:article]
      @game_session.save
    end

    if params[:article] == @game_session.game.end_url
      @game_session.ended_at = Time.now
      @game_session.save
      redirect_to win_path(@game_session)
    end

    game = @game_session.game

    @img_start_url = get_image_wiki(game.start_url)
    @img_end_url = get_image_wiki(game.end_url)

    # TODO, add geolocation to modify behaviour for different wikipedia languages
    url = "https://en.wikipedia.org/wiki/#{params[:article]}"
    html_file = URI.parse(url).open
    html_doc = Nokogiri::HTML(html_file)

    # Display only article
    html_doc = html_doc.search('#content')
    # Remove references list and category links
    html_doc.search('div.reflist', '#catlinks').remove

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
        # TODO, REMOVE THIS CONDITION, TEMPORARY
        if href == @game_session.game.end_url
          link['data-bs-toggle'] = "modal"
          link['data-bs-target'] = "#scoreModal"
        else
          link[:href] = "/game_session/#{@game_session.id}/#{href}" # Prepend every href stay in 'user_session/:id' path
        end
        # TODO, STIMULUS
        # link['data-action'] = 'click->play-page#changeArticle'
        # link['data-play-page-target'] = 'link'
        # TODO, Add link to check_available_links in current page
        # @user_sesion.available_links << link[:href].gsub(/#wiki\//, '')
      end
    end

    @html_game = html_doc.to_s
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
end
