import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['article', 'spinner']

  connect() {
    this.articleTarget.addEventListener('article:refresh', () => {
      this.scrollTop(this.articleTarget);
      this.pageReady();
    })
  }

  loading () {
    document.getElementById('game-page').classList.add('loading')
    this.spinnerTarget.classList.remove('d-none')
  }

  pageReady () {
    document.getElementById('game-page').classList.remove('loading')
    this.spinnerTarget.classList.add('d-none')
  }

  scrollTop(element) {
    element.scrollTo({ top: 0, behavior: 'smooth' });
  }
}
