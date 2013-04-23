module ConstructorCore
  # TODO
  module DeviseHelper
    def authenticate_user!
      warden.authenticate!
    end

    def user_signed_in?
      !!current_user
    end

    def current_user
      @current_user ||= warden.authenticate(:scope => :constructor_auth_user)
    end

    def user_session
      current_user && warden.session(:constructor_auth_user)
    end
    
    def warden
      request.env['warden']
    end
  end
end