class LobbiesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_lobby, only: :show

  def create
  end

  def show
  end

  def update
    @lobby = Lobby.find_by(code: params[:lobby][:code])
    redirect_to lobby_path(code: @lobby.code)
  end

  def start_game
  end

  def join_lobby
    #   Need to find another way of redirecting the user
    if params['code'].nil?
      #  Current_user ready status false
      @lobby = Lobby.create!(owner: current_user)
      @game = Game.create!(lobby: @lobby)
    else
      #  Check if lobby is open, if not warn user.
      #  Delete GameSessions that are open from current_user.
      #  Current_user ready status false.
      @lobby = Lobby.find_by(code: params['code'])
    end

    GameSession.create!(game: @lobby.games.where(running?: false).first,
                        user: current_user)

    redirect_to lobby_code_path(@lobby.code)
  end

  private

  def find_lobby
    @lobby = Lobby.find_by(code: params['code'])
  end
end
