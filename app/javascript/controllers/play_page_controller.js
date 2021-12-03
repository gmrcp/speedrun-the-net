import { Controller } from "stimulus"

export default class extends Controller {

  static targets = ['article', 'link'];

  // changeArticle() {
  //   console.log(this.articleTarget);
  //   console.log(this.linkTarget);
  // }
}
