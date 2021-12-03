changeArticle() {
  const url = `${this.formTarget.action}?query=${this.inputTarget.value}`
  fetch(url, { headers: { 'Accept': 'text/plain' } })
    .then(response => response.text())
    .then((data) => {
      this.articleTarget.innerHTML = data;
    })
}

thumbnails() {
  const url= `https://en.wikipedia.org/w/api.php?action=query&titles=${}&prop=pageimages&format=json&pithumbsize=100`;
}
