Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  get '/session', to: 'sessions#show'

  resources :lobbies, only: %i[show create update destroy] do
    resources :sessions, only: %i[show create update]
  end

  resources :games, only: %i[create update]

  # Check gem 'devise-guests' and 'auth discord'...
  resources :users, only: %i[create destroy]

  # ActionCable messages ???
end
