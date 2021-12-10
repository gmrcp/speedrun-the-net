class LobbiesController < ApplicationController
  before_action :authenticate_user!

  def show
    @message = Message.new
    @game_session = current_user.only_open_session
    redirect_to root_path, alert: 'Something went wrong...' and return if @game_session.nil?
  end

  def create
    current_user.game_sessions.open.destroy_all # Destroy all open game_sessions

    lobby = Lobby.create!(owner: current_user)
    game = Game.create!(lobby: lobby)
    GameSession.create!(game: game,
                        user: current_user,
                        avatar: rand(1..48))
    redirect_to lobby_path
  end

  def join
    lobby = Lobby.find_by(code: params[:lobby][:code])
    if lobby.nil?
      redirect_to lobby_path, alert: 'Sorry! Invalid code.'
    else
      current_user.game_sessions.open.destroy_all # Destroy all open game_sessions
      GameSession.create!(game: lobby.games.open.last,
                          user: current_user,
                          avatar: rand(1..48))
      redirect_to lobby_path
    end
  end

  def owner_start
    owner_session = current_user.only_open_session
    if owner_session.lobby.owner == current_user && params[:start_url] && params[:end_url] && params[:start_url] != params[:end_url]
      game = owner_session.game
      # params.permit(:start_url, :end_url)
      game.update!({ start_url: params[:start_url], end_url: params[:end_url], status: 1 })
      cable_ready[LobbyChannel]
        .console_log(message: "Owner is starting the game!")
        .append(
          selector: "body",
          html: "<a class='d-none' id='start-game-for-all' href='/start?end_url=#{game.end_url}&start_url=#{game.start_url}'></a>"
        )
        .dispatch_event(name: 'start:game')
        .broadcast_to(current_user.only_open_session.lobby)
    else
      redirect_to lobby_path, alert: 'Something went wrong while starting the game...'
    end
  end

  def ready
    game_session = current_user.only_open_session
    current_state = game_session.ready
    game_session.update!(ready: !current_state)

    # Update ready badge
    if game_session.ready
      cable_ready[LobbyChannel]
        .add_css_class(selector: "#{dom_id(game_session)} .fa-check-circle",
                       name: "player-is-ready")
        .broadcast_to(game_session.lobby)
    else
      cable_ready[LobbyChannel]
        .remove_css_class(selector: "#{dom_id(game_session)} .fa-check-circle",
                          name: "player-is-ready")
        .broadcast_to(game_session.lobby)
    end

    # Updates ready button based on ready state
    html = render_to_string(partial: 'lobbies/ready_button', locals: { game_session: game_session })
    render operations: cable_car
      .outer_html('#ready-button', html: html)
  end

  def return
    game_session = current_user.game_sessions.includes(:lobby, lobby: :owner).closed.last
    game = Game.where(lobby: game_session.lobby, status: 0).last
    if game.nil?
      game = Game.create(lobby: game_session.lobby)
    end
    GameSession.create(user: current_user, game: game)
    redirect_to lobby_path
  end

  def kick
    params.permit(:id)
    kicked_session = GameSession.find(params[:id])
    cable_ready[PlayersChannel]
      .dispatch_event(name: 'kick:player')
      .broadcast_to(kicked_session)
    kicked_session.destroy
  end

  def kicked
    redirect_to create_lobby_path, alert: 'You got kicked from your previous lobby.'
  end
end
