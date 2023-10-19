Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        collection do
          get 'find', to: 'merchants#find_one'
          get 'find_all', to: 'merchants#find_all'
        end
        resources :items, module: :merchants, only: [:index]
      end
      
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        get 'merchant', to: 'items/merchants#show', on: :member
        
        collection do   
          get 'find_all', to: 'items#search'
        end
      end
    end
  end
end 


