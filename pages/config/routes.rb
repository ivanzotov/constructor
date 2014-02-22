ConstructorPages::Engine.routes.draw do
  scope '/admin' do
    resources :pages, except: [:show] do
      collection do
        post :rebuild
        post :expand_node
      end
    end

    resources :templates, except: [:show] do
      collection do
        post :rebuild
        post :expand_node
      end

      resources :fields, except: [:show, :index] do
        collection do
          post :rebuild
        end
      end
    end
  end

  root to: 'pages#show'

  get '*path' => 'pages#show'
end
