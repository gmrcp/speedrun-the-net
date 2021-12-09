class Lobby < ApplicationRecord
  include CableReady::Broadcaster

  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  before_validation :generate_code
  has_many :games
  has_many :messages
  validates :code, length: { is: 4 }

  private

  def generate_code
    return if code.present?

    self.code = SecureRandom.hex(2).upcase # change the number for different size
  end
end
