ConstructorCap::Engine.routes.draw do
  scope '/admin' do
    resources :emails
    delete "/delete_all" => "emails#delete_all", :as => :delete_all
  end
  
  root :to => "emails#show"
  post "/email" => "emails#add"
end