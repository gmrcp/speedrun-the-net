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
    @lobby = current_user.lobbies.create
  end
end
