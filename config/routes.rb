Rails.application.routes.draw do
  mount ConstructorCore::Engine => '/', :as => :core
  mount ConstructorPages::Engine => '/', :as => :pages
end