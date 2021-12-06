import { Controller } from '@hotwired/stimulus'
import CableReady from 'cable_ready'

export default class extends Controller {
  static target = ['clicks', 'players']
  static values = { id: Number }

  connect() {
    console.log('ola')
    this.channel = this.application.consumer.subscriptions.create(
      {
        channel: 'PlayChannel',
        id: this.idValue
      },
      {
        received(data) { if (data.cableReady) CableReady.perform(data.operations) }
      }
    )
    console.log('adeus')
  }

  disconnect() {
    this.channel.unsubscribe()
  }
}
