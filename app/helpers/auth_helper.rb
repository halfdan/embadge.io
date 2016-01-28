# Helper methods defined here can be accessed in any controller or view in the application

module Embadge
  class App
    module AuthHelper
      def current_user
        @current_user ||= User.find_by_id(session[:current_user])
      end

      def logged_in?
        !current_user.nil?
      end

      def login_required
        unless logged_in?
          store_location!
          access_denied
        end
      end

      ##
      # Store in session[:return_to] the env['REQUEST_URI'].
      #
      def store_location!
        session[:return_to] = "#{ENV['RACK_BASE_URI']}#{env['REQUEST_URI']}" if env['REQUEST_URI']
      end

      ##
      # Redirect the account to the page that requested an authentication or
      # if the account is not allowed/logged return it to a default page.
      #
      def redirect_back_or_default(default)
        return_to = session.delete(:return_to)
        redirect(return_to || default)
      end

    private

      def access_denied
        halt 401, "You don't have permission for this resource"
      end
    end

    helpers AuthHelper
  end
end
