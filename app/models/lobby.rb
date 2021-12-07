class Lobby < ApplicationRecord
  include CableReady::Broadcaster

  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  before_validation :generate_code
  has_many :games

  after_update do
    cable_ready['players'].morph(
      # message: 'teste',
      # level: 'string'
      selector: "##{ActionView::RecordIdentifier.dom_id(self)}",
      html: ApplicationController.render(self)
    )
    cable_ready.broadcast
  end

  private

  def generate_code
    return if code.present?

    self.code = SecureRandom.hex(2).upcase # change the number for different size
  end
end
