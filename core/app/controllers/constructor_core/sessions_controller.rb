# encoding: utf-8

module ConstructorCore
  class SessionsController < Devise::SessionsController
    layout 'constructor_core/application_core'

    def after_sign_in_path_for(resource)
      return '/admin/pages'
    end

    def after_sign_out_path_for(resource)
      return '/'
    end
  end
end