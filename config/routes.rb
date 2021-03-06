Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      post '/auth', to: 'auth#create'
      get '/current_user', to: 'auth#show'

      resources :users, only: [:create, :update] do
        resources :posts, only: [:create, :index, :show, :update, :destroy]
      end

      resources :posts, only: [:index]

      resources :tags, only: [:index, :create]

      resources :post_tags, only: [:index, :create]

      get '/news', to: 'news#get_articles'
    end
  end
end
