Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      post '/auth', to: 'auth#create'
      get '/current_user', to: 'auth#show'

      resources :user, only: [:create] do
        resources :post, only: [:index, :create, :show, :update, :destroy]
      end

      resources :post, only: [:index]

      resources :tag, only: [:create]

      resources :post_tag, only: [:index, :create]

      get '/news', to: 'news#get_articles'
    end
  end
end
