class Message < ApplicationRecord
  belongs_to :user
  belongs_to :lobby

  include CableReady::Broadcaster

  def broadcast
    # binding.pry
    cable_ready["chat_channel"].insert_adjacent_html(
      selector: "#messages",
      position: 'beforeend',
      html: "<p id='message-#{id}'><strong>#{user.username}:</strong> #{content}</p>"
    )

    cable_ready["chat_channel"].scroll_into_view(
      behavior: 'smooth',
      selector: "#message-#{id}"
    )

    cable_ready.broadcast
  end
end
