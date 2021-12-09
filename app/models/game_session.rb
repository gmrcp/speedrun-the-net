class GameSession < ApplicationRecord

  belongs_to :game
  belongs_to :user
  has_one :lobby, through: :game

  enum status: { open: 0, playing: 1, closed: 2 }

  after_create do
    cable_ready[LobbyChannel]
      .append(selector: "#{dom_id(lobby)} .players",
              html: render(partial: 'shared/game_session', locals: { session: self, user: user }))
      .console_log(message: "User with game_session #{id} just joined")
      .broadcast_to(lobby)

    cable_ready[PlayersChannel]
      .append(
        selector: "#{dom_id(self)} .badges",
        html: render(partial: 'shared/kick_button', locals: { session: self})
      )
      .broadcast_to(sibling_game_sessions.find_by(user: lobby.owner))
  end

  after_update do
    cable_ready[LobbyChannel]
      .morph(selector: dom_id(self),
             html: render(partial: 'shared/game_session', locals: { session: self, user: user }))
      .morph(selector: "#ready-button",
             html: render(partial: 'lobbies/ready_button', locals: { session: self }))
      .broadcast_to(lobby)

    if sibling_game_sessions.where(ready: true).count >= sibling_game_sessions.count / 2
      cable_ready[LobbyChannel]
        .console_log(message: 'Majority is ready!')
        .broadcast_to(lobby)
    end

    cable_ready[PlayChannel]
      .text_content(selector: "#{dom_id(self)}>.num-clicks",
                    text: clicks.to_s)
      .console_log(message: "#{id} has #{clicks} clicks")
      .broadcast_to(lobby)
  end

  after_destroy do
    cable_ready[LobbyChannel]
      .remove(selector: dom_id(self))
      .console_log(message: "User with game_session #{id} just left the lobby")
      .broadcast_to(lobby)
  end

  def calculate_finish_time
    if ended_at && started_at
      total = ended_at - started_at
      seconds = format('%02d', total.floor % 60)
      minutes = format('%02d', total.floor / 60)
      formated_string = "#{seconds}s"
      formated_string = "#{minutes}min #{seconds}s" if minutes != '00'
      formated_string
    else
      'In Progress...'
    end
  end

  def calculate_final_score
    if ended_at.nil?
      'In Progress...'
    else
      (10_000 / (ended_at - started_at) * clicks).round
    end
  end

  def sibling_game_sessions
    GameSession.where(game: game)
  end
end
