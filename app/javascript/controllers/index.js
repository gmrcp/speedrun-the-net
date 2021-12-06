import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

window.Stimulus = Application.start()
// const context = require.context("./controllers", true, /\.js$/)
const context = require.context("controllers", true, /_controller\.js$/)
Stimulus.load(definitionsFromContext(context))

// const application = Application.start()
// const context = require.context("controllers", true, /_controller\.js$/)
// application.load(definitionsFromContext(context))
