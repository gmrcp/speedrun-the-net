changeArticle() {
  const url = `${this.formTarget.action}?query=${this.inputTarget.value}`
  fetch(url, { headers: { 'Accept': 'text/plain' } })
    .then(response => response.text())
    .then((data) => {
      this.articleTarget.innerHTML = data;
    })
}
