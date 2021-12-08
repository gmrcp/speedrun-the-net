import { Controller } from '@hotwired/stimulus'
import CableReady from 'cable_ready'

export default class extends Controller {
  static values = { id: Number }

  connect() {
    this.channel = this.application.consumer.subscriptions.create(
      {
        channel: 'LobbyChannel',
        id: this.idValue
      },
      {
        received (data) { if (data.cableReady) CableReady.perform(data.operations) }
      }
    )
    console.log(`You have subscribed to Lobby Channel ${this.idValue}`)
  }

  disconnect () {
    this.channel.unsubscribe()
  }
}
