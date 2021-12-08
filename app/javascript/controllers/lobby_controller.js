import { Controller } from '@hotwired/stimulus'
import CableReady from 'cable_ready'

export default class extends Controller {
  static values = { id: Number }

  connect() {
    // debugger
    this.channel = this.application.consumer.subscriptions.create(
      {
        channel: 'PlayersChannel',
        id: this.idValue
      },
      {
        received (data) { if (data.cableReady) CableReady.perform(data.operations) }
      }
    )
  }

  disconnect () {
    this.channel.unsubscribe()
  }
}
