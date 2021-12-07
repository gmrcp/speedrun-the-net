class GameSession < ApplicationRecord
  include CableReady::Broadcaster

  belongs_to :game
  belongs_to :user
  has_one :lobby, through: :game

  after_update do
    cable_ready['players'].morph(
      # message: 'teste',
      # level: 'string'
      selector: "##{ActionView::RecordIdentifier.dom_id(self)}",
      html: ApplicationController.render(self)
    )
    cable_ready.broadcast
  end
  # after_update do
  #   cable_ready['players'].inner_html(
  #     selector: "#game-id-#{self.game_id}",
  #     position: 'afterbegin',
  #     html: render(partial: 'game_session', locals: { session: self })
  #   )
  #   cable_ready.broadcast
  # end



    #     cable_ready['players'].insert_adjacent_html(
    #   selector: '#players',
    #   position: 'afterbegin',
    #   html: render_to_string(partial: "player", locals: { player: current_user })
    # )
    # cable_ready.broadcast

  # after_update do
  #   cable_ready['players'].morph(
  #     # message: 'teste',
  #     # level: 'string'
  #     selector: "##{ActionView::RecordIdentifier.dom_id(self)}",
  #     html: ApplicationController.render(self)
  #   )
  #   cable_ready.broadcast
  # end

  enum status: { open: 0, playing: 1, closed: 2 }

  after_save do
    # cable_ready[PlayChannel].text_content(
    #   selector: dom_id(self),
    #   text: self.clicks.count.to_s # render(partial: "games/game_detail", locals: { game: self})
    # ).broadcast_to(self)

    cable_ready[PlayChannel].morph(
      selector: "#{dom_id(self)} .num-clicks",
      html: "<p class='num-clicks'>#{clicks.count}</p>"
    ).broadcast_to(self)
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
