class LobbiesController < ApplicationController
  before_action :authenticate_user!

  def show
    redirect_to create_lobby_path if current_user.game_sessions.open.empty?
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
    current_user.game_sessions.open.destroy_all # Destroy all open game_sessions

    @lobby = Lobby.find_by(code: params[:code])
    GameSession.create!(game: @lobby.games.first,
                        user: current_user)
    redirect_to lobby_path
  end

  def start_game
  end

  def ready
    game_session = current_user.game_sessions.open.first
    cable_ready[LobbyChannel]
      .console_log("User with game_session #{game_session.id} is ready")
      .broadcast_to(game_session.lobby)
  end
end
