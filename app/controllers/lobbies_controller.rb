class LobbiesController < ApplicationController
  before_action :generate_lobby, only: :show

  def create
  end

  def show
  end

  def update
  end

  def start_game
  end

  private

  def generate_lobby
    @lobby = Lobby.create(owner: current_user, code: generate_code)
  end

  def generate_code
    # SecureRandom.hex(2)
    (0...6).map { ('A'..'Z').to_a[rand(26)] }.join
  end
end
