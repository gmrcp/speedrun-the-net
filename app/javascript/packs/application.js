// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import "controllers"
import "channels"
// import Rails from "@rails/ujs"
import CableReady from "cable_ready"
import mrujs from "mrujs";
import { CableCar } from "mrujs/plugins"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"

// Rails.start()
ActiveStorage.start()
mrujs.start({
  plugins: [
    new CableCar(CableReady)
  ]
})
Turbolinks.start()

// External imports:
//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap

// Internal imports:
import { bootstrapTooltips } from '../components/bootstrap_tooltips';
import { changeMainContainerHeight } from '../components/change_main_container_height';
import { displayTime } from '../components/timer';
import { preventBack } from '../components/prevent_back';
import { copyCode } from '../components/copy_clipboard';
import { selectWikiArticle } from '../components/select_wiki_article';

// $(document).on('turbolinks:load', function(){ $.rails.refreshCSRFTokens(); });

document.addEventListener('turbolinks:load', () => {
  if (document.getElementById('game-page')) {
    changeMainContainerHeight();
    bootstrapTooltips();
    preventBack();
    displayTime();
  }

  if (document.getElementById("lobbyCode")) {
    document.getElementById("lobbyCode").addEventListener('click', copyCode);
    const selectUrl = document.querySelectorAll('.tom-select')
    selectWikiArticle(selectUrl);
  }
});

$(document).ready(function () {
  $("#new_message").on("ajax:success", function (event) {
    $('#new_message')[0].reset();
  });
});
