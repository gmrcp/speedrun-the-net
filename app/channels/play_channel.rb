class PlayChannel < ApplicationCable::Channel
  def subscribed
    stream_or_reject_for GameSession.find_by(id: params[:id])
  end
end
