Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'merchants/find_all', to: 'merchants#find_all'
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
      end

      get 'items/find', to: 'items#find'
      resources :items do
        get '/merchant', to: 'merchants#show'
      end
    end
  end
end
