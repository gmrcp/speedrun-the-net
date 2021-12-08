class GameSession < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_one :lobby, through: :game

  enum status: { open: 0, playing: 1, closed: 2 }

  after_save do
    # cable_ready[PlayChannel].text_content(
    #   selector: dom_id(self),
    #   text: self.clicks.count.to_s # render(partial: "games/game_detail", locals: { game: self})
    # ).broadcast_to(self)

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
    formated_string = "#{minutes}min #{seconds}s" if minutes != '00'
    formated_string
  end
end
