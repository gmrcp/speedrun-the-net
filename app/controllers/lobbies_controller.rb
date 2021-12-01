class LobbiesController < ApplicationController
  def create
  end

  def show
    @lobby = Lobby.find(params[:id])
    @message = Message.new
  end

  def update
  end

  def start_game
  end
end
