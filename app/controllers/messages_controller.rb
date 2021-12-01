class MessagesController < ApplicationController
  def create
    @lobby = Lobby.find(params[:lobby_id])
    @message = Message.new(message_params)
    @message.lobby = @lobby
    @message.user = current_user
    if @message.save
      LobbieChannel.broadcast_to(@lobby, render_to_string(partial: "message", locals: { message: @message }))
      redirect_to lobbie_path(@lobby, anchor: "message-#{@message.id}")
    else
      render "lobbies/show"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
