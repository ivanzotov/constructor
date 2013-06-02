ConstructorPages::Engine.routes.draw do
  scope '/admin' do
    resources :pages, :except => [:show]
<<<<<<< HEAD
=======
    resources :templates, :except => [:show]
    resources :fields, :except => [:show, :new, :edit]

    scope '/fields' do
      get ':template_id/new/' => 'fields#new', :as => :new_field
      get ':id/:template_id/edit/' => 'fields#edit', :as => :edit_field

      get 'move/up/:id' => "fields#move_up", :as => :field_move_up
      get 'move/down/:id' => "fields#move_down", :as => :field_move_down
    end
>>>>>>> develop

    scope '/pages' do
      post 'move/up/:id' => "pages#move_up", :as => :page_move_up
      post 'move/down/:id' => "pages#move_down", :as => :page_move_down
      
      get ':page/new' => "pages#new", :as => :new_child_page
    end

    scope '/templates' do
      post 'move/up/:id' => "templates#move_up", :as => :template_move_up
      post 'move/down/:id' => "templates#move_down", :as => :template_move_down
    end
  end
<<<<<<< HEAD
  
  get '/sitemap' => "pages#sitemap", :as => :sitemap
=======
>>>>>>> develop

  root :to => "pages#show"
  get '*all/search/:what_search' => "pages#search", :format => false
  get '*all.:format' => "pages#show"
  get '*all' => "pages#show"
end
