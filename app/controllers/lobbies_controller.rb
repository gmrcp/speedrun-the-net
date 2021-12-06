class LobbiesController < ApplicationController
  before_action :authenticate_user!
  # before_action :generate_lobby, only: :show

  def create
  end

  def show
    #   Need to find another way of redirecting the user
    # @lobby = Lobby.find_by(code: params['code']['code']) if params['code']['code']
    if params['code'].nil?
      @lobby = Lobby.create!(owner: current_user)
      @game = Game.create!(lobby: @lobby)
    else
      @lobby = Lobby.find_by(code: params['code']['code'])
    end

    GameSession.create!(game: @lobby.games.where(running?: false).first,
                        user: current_user)
  end

  def update
  end

  def start_game
  end

  private

end
