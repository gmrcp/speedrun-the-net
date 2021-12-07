class LobbiesController < ApplicationController
  include CableReady::Broadcaster

  before_action :authenticate_user!
  before_action :find_lobby, only: :show
  # before_action :update_players, only: :show
  # before_action :remove_player, only: :update

  def create
  end

  def show
  end

  def update_players
    cable_ready['players'].insert_adjacent_html(
      selector: '#players',
      position: 'afterbegin',
      html: render_to_string(partial: "player", locals: { player: current_user })
    )
    cable_ready.broadcast
  end

  def update
    @lobby = Lobby.find_by(code: params[:lobby][:code])
    redirect_to lobby_path(code: @lobby.code)
  end

  def start_game
  end

  def remove_player
    game_session = current_user.game_sessions.find_by(status: 'open').first
    cable_ready['players'].remove(
      selector: "#data-player-id=#{game_session.user.id}"
    )
    cable_ready.broadcast
    game_session.destroy!
  end

  def join_lobby
    if params['code'].nil?
      #  Current_user ready status false
      @lobby = Lobby.create!(owner: current_user)
      @game = Game.create!(lobby: @lobby)
    else
      remove_player
      @lobby = Lobby.find_by(code: params['code'])
    end
    @game_session = GameSession.create!(game: @lobby.games.where(running?: false).first,
                                        user: current_user)

    redirect_to lobby_code_path(@lobby.code)
    update_players
  end

  private

  def find_lobby
    @lobby = Lobby.find_by(code: params['code'])
  end
end
