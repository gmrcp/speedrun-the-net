Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth'}

  root to: 'pages#home'

  get '/session', to: 'sessions#show'

  get :start, to: 'game_sessions#start_game'

  get 'game_session/:id/:article', to: 'game_sessions#play', as: :play

  resource :lobby, only: :show
  resources :lobbies, only: %i[create update destroy] do
    resources :game_sessions, only: %i[show create update]
  end

  resources :games, only: %i[create update]

  # Check gem 'devise-guests' and 'auth discord'...
  resources :users, only: %i[create destroy]

  # ActionCable messages ???
end
