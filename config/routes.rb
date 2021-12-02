Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth'}
  root to: 'pages#home'

  get '/session', to: 'sessions#show'

  resource :lobby, only: :show
  resources :lobbies, only: %i[create update destroy] do
    resources :game_sessions, only: %i[show create update]
  end

  resources :games, only: %i[create update]

  # Check gem 'devise-guests' and 'auth discord'...
  resources :users, only: %i[create destroy]

  # ActionCable messages ???
end
