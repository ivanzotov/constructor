# encoding: utf-8

module ConstructorCore
  class ApplicationController < ::ApplicationController
    layout 'constructor_core/application_core'
    before_filter :authenticate_user!, :except => [:show, :search]

    helper_method :current_user

    private

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
  end
end