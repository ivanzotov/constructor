ConstructorCore::Engine.routes.draw do
  scope 'admin' do
    get 'profile/:id' => 'users#profile', as: :user
    post 'profile/:id' => 'users#update_password'

    devise_for :users, {
        class_name: 'ConstructorCore::User',
        module: :devise
    }
  end

  as :user do
    get '/admin' => 'sessions#new'
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    delete '/logout' => 'sessions#destroy'
  end
end