class Game < ApplicationRecord
  belongs_to :lobby
  has_many :sessions
end
