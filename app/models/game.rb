class Game < ApplicationRecord
  belongs_to :lobby
  has_many :game_sessions
  has_many :users, through: :game_sessions

  enum status: { open: 0, playing: 1, closed: 2 }

end
