class Message < ApplicationRecord
  belongs_to :user
  belongs_to :lobby

  include CableReady::Broadcaster

  def broadcast
    # binding.pry
    cable_ready["chat_channel"].insert_adjacent_html(
      selector: "#messages",
      position: 'beforeend',
      html: "<p><strong>#{user.username}:</strong>#{content}</p>"
    )

    cable_ready.broadcast
  end
end
