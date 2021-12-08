class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_or_reject_for Lobby.find(params[:id])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
