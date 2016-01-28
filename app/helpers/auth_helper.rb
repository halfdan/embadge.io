# Helper methods defined here can be accessed in any controller or view in the application

module Embadge
  class App
    module AuthHelper
      def current_user
        @current_user ||= User.find_by_id(session[:current_user])
      end

      def is_logged_in?
        return current_user.present?
      end
    end

    helpers AuthHelper
  end
end
