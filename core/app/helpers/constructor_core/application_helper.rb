module ConstructorCore
  module ApplicationHelper
    def authenticate_user!
      warden.authenticate!
    end

    def user_signed_in?
      !!current_user
    end

    def current_user
      @current_user ||= warden.authenticate
    end

    def user_session
      current_user && warden.session
    end

    def warden
      request.env['warden']
    end

    def gravatar_icon(user_email = '', size = 40)
      gravatar_url = 'http://www.gravatar.com/avatar/%{hash}?s=%{size}&d=mm'
      user_email.strip!
      sprintf gravatar_url, hash: Digest::MD5.hexdigest(user_email.downcase), size: size
    end
  end
end