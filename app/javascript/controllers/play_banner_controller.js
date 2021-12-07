import { Controller } from '@hotwired/stimulus'
import CableReady from 'cable_ready'

export default class extends Controller {
  static targets = ['clicks', 'players']
  static values = { id: Number }

  connect() {
    this.clicksTarget.channel = this.application.consumer.subscriptions.create(
      {
        channel: 'PlayChannel',
        id: this.idValue
      },
      {
        received(data) { if (data.cableReady) CableReady.perform(data.operations) }
      }
      )
    console.log('play-banner#clicks subscribed to PlayChannel')
  }

  disconnect() {
    this.clicksTarget.channel.unsubscribe()
  }
}
