const { environment } = require('@rails/webpacker')

const webpack = require('webpack');
// Preventing Babel from transpiling NodeModules packages
environment.plugins.append("Provide", new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery'
}))

environment.loaders.delete('nodeModules');
module.exports = environment
