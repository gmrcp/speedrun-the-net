class Game < ApplicationRecord
  belongs_to :lobby
  has_many :game_sessions

  def wiki(which_url)
    self[which_url].split('/').last
  end
end
