import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = { id: Number }

  connect() {
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
}
