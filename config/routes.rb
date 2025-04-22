Rails.application.routes.draw do
  devise_for :users
  root 'playlists#index'

  # Routes pour le profil
  resource :profile, only: [:edit, :update]

  resources :playlists, only: [:index, :show] do
    resources :games, only: [:new, :create, :show] do
      post 'swipe', on: :member
    end
  end

  resources :scores, only: [:index, :show]
  resources :swipes, only: [:create]

  namespace :admin do
    resources :playlists, only: [:new, :create]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
