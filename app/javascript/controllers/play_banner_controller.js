// LOBBY id channel

import { Controller } from '@hotwired/stimulus'
import CableReady from 'cable_ready'

export default class extends Controller {
  static targets = ['clicks', 'players']
  static values = { id: Number }

  connect() {
    this.channel = this.application.consumer.subscriptions.create(
      {
        channel: 'PlayChannel',
        id: this.idValue
      },
      {
        received(data) { if (data.cableReady) CableReady.perform(data.operations) }
      }
    )
    console.log(`User has subscribed to PlayChannel ${this.idValue}`)

    document.addEventListener("win:game", () => {
      this.highlight();
      this.openModal()
    }, { once: true });

  }

  openModal() {
    const modal = new bootstrap.Modal(document.getElementById('main-modal'));
    modal.show();
  }

  highlight() {
    const player_card = document.getElementById(`game_session_${this.idValue}-finish`)
    player_card.classList.add('user-highlight-lobby')
  }

  disconnect() {
    this.channel.unsubscribe()
  }
}
