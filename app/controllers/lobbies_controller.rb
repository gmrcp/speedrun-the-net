class LobbiesController < ApplicationController
  before_action :authenticate_user!

  def show
    redirect_to create_lobby_path and return if current_user.only_open_session.nil?
    @lobby = current_user.only_open_session.lobby
  end

  def create
    current_user.game_sessions.open.destroy_all # Destroy all open game_sessions

    @lobby = Lobby.create!(owner: current_user)
    game = Game.create!(lobby: @lobby)
    GameSession.create!(game: game,
                        user: current_user)
    redirect_to lobby_path
  end

  def join
    lobby = Lobby.find_by(code: params[:lobby][:code])
    if lobby.nil?
      @lobby = current_user.only_open_session.lobby
      redirect_to lobby_path, alert: 'Sorry! Invalid code.'
    else
      @lobby = lobby
      current_user.game_sessions.open.destroy_all # Destroy all open game_sessions
      GameSession.create!(game: @lobby.games.first,
                          user: current_user)
      redirect_to lobby_path
    end
  end

  def start_game
  end

  def ready
    game_session = current_user.game_sessions.open.first
    cable_ready[LobbyChannel]
      # .append("<a href='/start?end_url=Jazz&amp;start_url=Joe_Biden'></a>")
      .console_log(message: "User with game_session #{game_session.id} is ready")
      .dispatch_event(name: 'start:game')
      .broadcast_to(game_session.lobby)
  end
end
