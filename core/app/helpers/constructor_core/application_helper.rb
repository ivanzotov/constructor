module ConstructorCore
  module ApplicationHelper
    def menu_item(name, icon)
      link_to "/admin/#{name}", class: "b-menu__item-link #{'b-menu__item-link_active' if request.path == "/admin/#{name}"}" do
        "<i class='fa fa-#{icon} b-menu__item-icon'></i> #{t name.to_sym}".html_safe
      end
    end

    def gravatar_icon(user_email = '', size = 40)
      gravatar_url = 'http://www.gravatar.com/avatar/%{hash}?s=%{size}&d=mm'
      user_email.strip!
      sprintf gravatar_url, hash: Digest::MD5.hexdigest(user_email.downcase), size: size
    end
  end
end