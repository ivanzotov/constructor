ConstructorCore::Engine.routes.draw do
  devise_for :users, {
      class_name: 'ConstructorCore::User',
      skip: [:sessions, :passwords],
      module: :devise
  }

  as :user do
    get '/admin' => 'sessions#new'
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy'
  end
end