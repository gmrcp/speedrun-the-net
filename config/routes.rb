Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # devise_scope :user do
  #   delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end

  root to: 'pages#home'

  get :ready, to: 'lobbies#ready'

  get :start, to: 'game_sessions#start_game'
  post :start, to: 'game_sessions#start_game'

  get 'game_session/:id/:article', to: 'game_sessions#play', as: :play

  get 'lobby', to: 'lobbies#create_lobby', as: :lobby
  get 'lobby/:code', to: 'lobbies#join_lobby', as: :lobby_code
  patch 'lobby/:code', to: 'lobbies#join_lobby'

end
