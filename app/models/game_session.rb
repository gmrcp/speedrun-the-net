class GameSession < ApplicationRecord
  include CableReady::Broadcaster

  belongs_to :game
  belongs_to :user

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

  def calculate_finish_time
    total = ended_at - started_at
    seconds = format('%02d', total.floor % 60)
    minutes = format('%02d', total.floor / 60)
    formated_string = "#{seconds}s"
    formated_string.unshift("#{minutes}min ") if minutes != '00'
    formated_string
  end
end
