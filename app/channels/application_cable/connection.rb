module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :session_id

    def connect
      self.session_id = request.session.id
    end

    # private

    # def find_verified_user
    #   if verified_user = User.find_by(id: cookies.encrypted[:user_id])
    #     verified_user
    #   else
    #     reject_unauthorized_connection
    #   end
    # end
  end
end
