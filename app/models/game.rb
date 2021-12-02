class Game < ApplicationRecord
  belongs_to :lobby
  has_many :game_sessions
  has_many :users, through: :game_sessions
end
