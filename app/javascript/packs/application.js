// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "controllers"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// External imports:
//= require jquery3
//= require popper
//= require bootstrap

// Internal imports:
import { bootstrapTooltips } from '../components/bootstrap_tooltips';
import { changeMainContainerHeight } from '../components/change_main_container_height'

document.addEventListener('turbolinks:load', () => {
  if (document.getElementById('game-page')) {
    changeMainContainerHeight();
    bootstrapTooltips();
  }
});
