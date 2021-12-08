class Game < ApplicationRecord
  include CableReady::Broadcaster
  belongs_to :lobby
  has_many :game_sessions
  has_many :users, through: :game_sessions

end
