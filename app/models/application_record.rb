class ApplicationRecord < ActiveRecord::Base
  include CableReady::Broadcaster
  self.abstract_class = true
  delegate :render, to: :ApplicationController

  def sgid
    to_sgid(expires_in: nil).to_s
  end
end
