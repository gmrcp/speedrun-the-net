class PlayersChannel < ApplicationCable::Channel
  def subscribed
    stream_or_reject_for GameSession.find(params[:id])
  end
end
