import { Controller } from "@hotwired/stimulus"


// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ['container'];

  connect() {
    // const modal = new bootstrap.Modal(document.getElementById('score-modal'));
    document.addEventListener("win:game", () => {
      this.open()
    }, { once: true });
  }

  open() {
    const modal = new bootstrap.Modal(document.getElementById('main-modal'));
    modal.show();
  }
}
