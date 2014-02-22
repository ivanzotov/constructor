module ConstructorCore
  class SessionsController < Devise::SessionsController
    layout 'constructor_core/login'

    def after_sign_in_path_for(resource)
      return '/admin/pages'
    end

    def after_sign_out_path_for(resource)
      return '/'
    end
  end
end