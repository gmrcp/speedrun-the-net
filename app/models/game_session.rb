class GameSession < ApplicationRecord

  belongs_to :game
  belongs_to :user
  has_one :lobby, through: :game

  enum status: { open: 0, playing: 1, closed: 2 }

  after_create do
    # append player card in lobby
    cable_ready[LobbyChannel]
      .append(selector: "#{dom_id(lobby)} .players",
              html: render(partial: 'shared/game_session', locals: { session: self, user: user }))
      .console_log(message: "User with game_session #{id} just joined")
      .broadcast_to(lobby)

    # if more than 1 player in lobby, show ready counter
    if sibling_game_sessions.count > 1
      check_owner_disabled_button_status
      cable_ready[LobbyChannel]
        .text_content(selector: '#ready-counter',
                      text: "#{sibling_game_sessions.where(ready: true).count}/#{sibling_game_sessions.count} ready")
        .remove_css_class(selector: '#ready-counter', name: 'd-none')
        .broadcast_to(lobby)
    end

    # Give the owner of lobby -> Leader badge
    cable_ready[PlayersChannel]
      .append(
        selector: "#{dom_id(self)} .badges",
        html: render(partial: 'shared/kick_button', locals: { session: self})
      )
      .broadcast_to(sibling_game_sessions.find_by(user: lobby.owner))
  end

  after_update do
    # if majority has readied, owner start button is enabled / disabled
    check_owner_disabled_button_status

    # Update num clicks in play page
    cable_ready[PlayChannel]
      .text_content(selector: "#{dom_id(self)}>.num-clicks",
                    text: clicks.to_s)
      .console_log(message: "#{id} has #{clicks} clicks")
      .broadcast_to(lobby)
  end

  after_destroy do
    # remove player card from lobby
    cable_ready[LobbyChannel]
      .remove(selector: dom_id(self))
      .console_log(message: "User with game_session #{id} just left the lobby")
      .broadcast_to(lobby)

    # if only 1 player in lobby, hide ready counter
    if sibling_game_sessions.count <= 1
      cable_ready[LobbyChannel]
        .add_css_class(selector: '#ready-counter', name: 'd-none')
        .broadcast_to(lobby)
    end
  end

  def calculate_finish_time
    if ended_at && started_at
      total = ended_at - started_at
      seconds = total.floor % 60
      minutes = total.floor / 60
      formated_string = "#{seconds}s"
      formated_string = "#{minutes}m #{seconds}s" if minutes != 0
      formated_string
    else
      'In Progress...'
    end
  end

  def calculate_final_score
    ended_at.nil? || started_at.nil? ? 0 : (100_000 / (ended_at - started_at) * clicks).round
  end

  def sibling_game_sessions
    GameSession.where(game: game)
  end

  private

  def check_owner_disabled_button_status
    if sibling_game_sessions.where(ready: true).count >= sibling_game_sessions.count / 2
      cable_ready[PlayersChannel]
        .console_log(message: 'Majority is ready!')
        .remove_attribute(selector: '#owner-start-button', name: 'disabled')
        .broadcast_to(lobby.owner)
    else
      cable_ready[PlayersChannel]
        .console_log(message: 'Majority is NOT ready!')
        .set_attribute(selector: '#owner-start-button', name: 'disabled')
        .broadcast_to(lobby.owner)
    end
  end
end
