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
  }

  disconnect() {
    this.channel.unsubscribe()
  }
}
