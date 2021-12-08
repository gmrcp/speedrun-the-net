class GameSession < ApplicationRecord
  include CableReady::Broadcaster

  belongs_to :game
  belongs_to :user
  has_one :lobby, through: :game

  enum status: { open: 0, playing: 1, closed: 2 }

  after_update do
    if open?
      cable_ready['players'].append(
        selector: "#lobby-id-#{game.lobby.id}",
        html: render(partial: self, locals: { session: self })
      )
      cable_ready.broadcast

    elsif closed?
      cable_ready['players'].remove(
        selector: "#lobby-id-#{game.lobby.id}"
      )
      cable_ready.broadcast
    end
  end

  after_save do
    cable_ready[PlayChannel].morph(
      selector: "#{dom_id(self)} .num-clicks",
      html: "<p class='num-clicks'>#{clicks.count}</p>"
    ).broadcast_to(self)
  end

  def calculate_finish_time
    total = ended_at - started_at
    seconds = format('%02d', total.floor % 60)
    minutes = format('%02d', total.floor / 60)
    formated_string = "#{seconds}s"
    formated_string.unshift("#{minutes}min ") if minutes != '00'
    formated_string
  end
end
