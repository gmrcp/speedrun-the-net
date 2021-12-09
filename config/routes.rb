Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }
  # devise_scope :user do
  #   delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end

  root to: 'pages#home'

  get :ready, to: 'lobbies#ready'
  get :lobby, to: 'lobbies#show'
  get :create, to: 'lobbies#create', as: :create_lobby
  post :join, to: 'lobbies#join', as: :join_lobby
  post :return, to: 'lobbies#return'
  delete '/kick/:id', to: 'lobbies#kick', as: :kick

  get '/kicked', to: 'lobbies#kicked'

  post :owner_start, to: 'lobbies#owner_start'

  get :start, to: 'game_sessions#start_game'
  post :start, to: 'game_sessions#start_game'

  get 'game_session/:id/:article', to: 'game_sessions#play', as: :play
end
