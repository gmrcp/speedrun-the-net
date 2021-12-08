class LobbiesController < ApplicationController
  include CableReady::Broadcaster

  before_action :authenticate_user!
  before_action :find_lobby, only: :join_lobby

  def create
  end

  def show
    # @lobby.games.first.game_sessions.first.save!
  end

  def create_lobby
    @lobby = Lobby.create!(owner: current_user)
    @game = Game.create!(lobby: @lobby)
    # @game_session = GameSession.create!(game: @lobby.games.first,
    #                                     user: current_user)
    #                                     @game_session.save!
    redirect_to lobby_code_path(@lobby.code)
  end

  def join_lobby
    @game_session = GameSession.create!(game: @lobby.games.first,
                                        user: current_user)
    render :show
    @game_session.save!
  end

  def start_game
  end

  def ready
    game_session = current_user.game_sessions.open.first
    cable_ready[LobbyChannel]
      .console_log("User with game_session #{game_session.id} is ready")
      .broadcast_to(game_session.lobby)
  end

  private

  def find_lobby
    current_user.game_sessions.open.first.closed! unless current_user.game_sessions.open.empty?
    if params[:_method] == 'patch'
      @lobby = Lobby.find_by(code: params[:lobby][:code])
    else
      @lobby = Lobby.find_by(code: params[:code])
    end
  end
end
