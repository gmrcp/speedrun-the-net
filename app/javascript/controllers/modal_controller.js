import { Controller } from "@hotwired/stimulus"


// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ['container'];

  connect() {
    const modal = new bootstrap.Modal(document.getElementById('scoreModal'));
  }

  open() {
    modal.toggle();
  }
}
