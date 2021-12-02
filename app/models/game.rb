class Game < ApplicationRecord
  belongs_to :lobby
  has_many :game_sessions
end
