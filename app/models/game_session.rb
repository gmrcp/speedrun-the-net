class GameSession < ApplicationRecord
  belongs_to :game
  belongs_to :user

  enum status: { open: 0, playing: 1, closed: 2 }

  def calculate_finish_time
    total = ended_at - started_at
    seconds = format('%02d', total.floor % 60)
    minutes = format('%02d', total.floor / 60)
    formated_string = "#{seconds}s"
    formated_string.unshift("#{minutes}min ") if minutes != '00'
    formated_string
  end
end
