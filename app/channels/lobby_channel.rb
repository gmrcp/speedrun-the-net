class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'players'
    # stream_for Lobby.find_by(code: params[:code])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
