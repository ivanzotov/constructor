ConstructorPages::Engine.routes.draw do
  scope '/admin' do
    resources :pages, :except => [:show]
    scope '/pages' do
      post 'move/up/:id' => "pages#move_up", :as => :move_up
      post 'move/down/:id' => "pages#move_down", :as => :move_down
      
      get ':page/new' => "pages#new", :as => :new_child_page
    end
    
    resources :images, :except => [:show, :new, :edit]         
    get 'images/:page/new' => "images#new"
    get 'images/:id/:page/edit' => "images#edit", :as => :edit_image   
    get 'images/:id/sizes' => "images#sizes", :as => :sizes_image    
  end
  
  get '/sitemap' => "pages#sitemap", :as => :sitemap
  
  #get '/pages/regenerate_urls' => "pages#regenerate_urls", :as => :regenerate_urls
  
  

  
  root :to => "pages#show"
  get '*all' => "pages#show", :format => false
end
