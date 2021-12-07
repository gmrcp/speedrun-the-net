import { Controller } from '@hotwired/stimulus'
import CableReady from 'cable_ready'

export default class extends Controller {
  static values = { id: Number }

  connect() {
    this.channel = this.application.consumer.subscriptions.create(
      {
        channel: 'LobbyChannel',
        code: document.querySelector('#lobbyCode').value
      },
      {
        received (data) { if (data.cableReady) CableReady.perform(data.operations) }
      }
    )
    console.log('coiso');
  }

  disconnect () {
    this.channel.unsubscribe()
  }
}
