class LobbiesController < ApplicationController
  before_action :authenticate_user!

  def show
    @game_session = current_user.only_open_session
    redirect_to root_path, alert: 'Something went wrong...' and return if @game_session.nil?
  end

  def create
    current_user.game_sessions.open.destroy_all # Destroy all open game_sessions

    lobby = Lobby.create!(owner: current_user)
    game = Game.create!(lobby: lobby)
    GameSession.create!(game: game,
                        user: current_user)
    redirect_to lobby_path
  end

  def join
    lobby = Lobby.find_by(code: params[:lobby][:code])
    if lobby.nil?
      redirect_to lobby_path, alert: 'Sorry! Invalid code.'
    else
      current_user.game_sessions.open.destroy_all # Destroy all open game_sessions
      GameSession.create!(game: lobby.games.first,
                          user: current_user)
      redirect_to lobby_path
    end
  end

  def owner_start
    owner_session = current_user.only_open_session
    if owner_session.lobby.owner == current_user && params[:start_url] && params[:end_url]
      game = owner_session.game
      params.permit(:start_url, :end_url)
      game.update!({ start_url: params[:start_url], end_url: params[:end_url] })
      cable_ready[LobbyChannel]
        .console_log(message: "Owner is starting the game!")
        .append(
          selector: "body",
          html: "<a class='d-none' id='start-game-for-all' href='/start?end_url=#{game.end_url}&start_url=#{game.start_url}'></a>"
        )
        .dispatch_event(name: 'start:game')
        .broadcast_to(current_user.only_open_session.lobby)
    else
      redirect_to lobby_path, alert: 'Something went wrong while starting the game...'
    end
  end

  def ready
    game_session = current_user.only_open_session
    current_state = game_session.ready
    game_session.update!(ready: !current_state)
    # render :nothing
    #render operations: cable_car.console_log(message: "You just clicked the ready  button")
    # total_game_sessions = game_session.sibling_game_sessions
    # cable_ready[LobbyChannel]
    #   .console_log(
    #     message: "User with game_session #{game_session.id} is #{game_session.ready? ? 'ready' : 'not ready'}"
    #   )
    #   .text_content(
    #     selector: "#ready-button",
    #     text: "#{total_game_sessions.where(ready?: true).count}/#{total_game_sessions.count}"
    #   )
    #   .broadcast_to(game_session.lobby)
  end
end
