class LobbyChannel < ApplicationCable::Channel
  def subscribed
    lobby = Lobby.find(params[:id])
    stream_for lobby
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
