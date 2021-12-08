class LobbiesController < ApplicationController
  before_action :authenticate_user!

  def show
    @game_session = current_user.only_open_session
    redirect_to root_path, alert: 'Something went wrong...' and return if @game_session.nil?
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
    game_session = current_user.only_open_session
    game_session.update!(ready?: !game_session.ready?)
    total_game_sessions = game_session.sibling_game_sessions
    cable_ready[LobbyChannel]
      .console_log(
        message: "User with game_session #{game_session.id} is #{game_session.ready? ? 'ready' : 'not ready'}"
      )
      .text_content(
        selector: "#ready-button",
        text: "#{total_game_sessions.where(ready?: true).count}/#{total_game_sessions.count}"
      )
      .broadcast_to(game_session.lobby)
  end
end
