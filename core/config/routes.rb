ConstructorCore::Engine.routes.draw do 
  get '/admin' => redirect('/admin/pages')
  
  devise_for "constructor_core/users", :skip => [:sessions, :passwords] do
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy'
  end  
end