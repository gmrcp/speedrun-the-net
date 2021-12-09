class GameSession < ApplicationRecord

  belongs_to :game
  belongs_to :user
  has_one :lobby, through: :game

  enum status: { open: 0, playing: 1, closed: 2 }

  # after_update do
  #   if open?
  #     cable_ready["players"].append(
  #       selector: "#lobby-id-#{game.lobby.id}",
  #       html: render(partial: self, locals: { session: self })
  #     )
  #     cable_ready.broadcast

  #   elsif closed?
  #     cable_ready['players'].remove(
  #       selector: "#lobby-id-#{game.lobby.id}"
  #     )
  #     cable_ready.broadcast
  #   end
  # end

  # after_save do
  #   cable_ready[PlayChannel].morph(
  #     selector: "#{dom_id(self)} .num-clicks",
  #     html: "<p class='num-clicks'>#{clicks}</p>"
  #   ).broadcast_to(self)
  # end

  after_create do
    cable_ready[LobbyChannel]
      .append(selector: "#{dom_id(lobby)} .players",
              html: render(partial: self, locals: { session: self }))
      .console_log("User with game_session #{id} just joined")
      .broadcast_to(lobby)
  end

  after_destroy do
    cable_ready[LobbyChannel]
      .remove(selector: "#{dom_id(self)}")
      .console_log("User with game_session #{id} just left the lobby")
      .broadcast_to(lobby)
  end

  def calculate_finish_time
    total = ended_at - started_at
    seconds = format('%02d', total.floor % 60)
    minutes = format('%02d', total.floor / 60)
    formated_string = "#{seconds}s"
    formated_string.unshift("#{minutes}min ") if minutes != '00'
    formated_string
  end
end
