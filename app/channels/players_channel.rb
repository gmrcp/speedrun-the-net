class PlayersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "players"

    Lobby.find(params[:id])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
