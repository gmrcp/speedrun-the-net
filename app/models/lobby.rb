class Lobby < ApplicationRecord
  belongs_to :owner, class_name: "User"
  before_validation :generate_code

  private

  def generate_code
    return if code.present?

    self.code = SecureRandom.hex(2) # change the number for different size
  end

end
