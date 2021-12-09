class PlayChannel < ApplicationCable::Channel
  def subscribed
    stream_or_reject_for Lobby.find(params[:id])
  end
end
