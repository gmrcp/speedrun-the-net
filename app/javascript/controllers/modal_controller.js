import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = { id: Number }

  connect() {
    document.addEventListener("win:game", () => {
      this.openModal()
    }, { once: true });

    document.addEventListener("win:lobby", () => {
      this.highlight();
    })
  }

  openModal() {
    const modal = new bootstrap.Modal(document.getElementById('main-modal'));
    modal.show();
  }

  highlight() {
    const player_card = document.getElementById(`game_session_${this.idValue}_finish`)
    player_card.classList.add('user-highlight-play')
  }
}
