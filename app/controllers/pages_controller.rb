class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    reset_session
  end
end
