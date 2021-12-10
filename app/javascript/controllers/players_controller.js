// GAME SESSION id channel - lobby show view
// allows INDIVIDUAL events

import { Controller } from '@hotwired/stimulus'
import CableReady from 'cable_ready'

export default class extends Controller {
  static values = { id: Number }

  connect() {
    this.channel = this.application.consumer.subscriptions.create(
      {
        channel: 'PlayersChannel',
        id: this.idValue
      },
      {
        received(data) { if (data.cableReady) CableReady.perform(data.operations) }
      }
    )

    document.addEventListener('kick:player', () => {
      this.kick();
    })

    this.highlight();
  }

  highlight() {
    const player_card = document.getElementById(`game_session_${this.idValue}`)
    player_card.classList.add('user-highlight-lobby')
  }

  kick() {
    window.location = "/kicked";
  }

  disconnect() {
    this.channel.unsubscribe()
  }
}
