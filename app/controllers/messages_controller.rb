class MessagesController < ApplicationController
  def index
    @message = Message.new
    @messages = Message.order('created_at DESC')
  end

  def create
    @lobby = Lobby.find(params[:lobby_id])
    @message = Message.new(message_params)
    @message.lobby = @lobby
    @message.user = current_user
    @message.save!
    @message.broadcast
    # redirect_to anchor: "message-#{@message.id}"

     # LobbieChannel.broadcast_to(@lobby, render_to_string(partial: "message", locals: { message: @message }))
    # redirect_to lobbie_path(@message, anchor: "message-#{@message.id}")
    # else
    #   render "lobbies/show"
    # end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
