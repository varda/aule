$ = require 'jquery'

module.exports = (options) ->
  $('h1').html options.fn @
  $('title').html 'Aule - ' + options.fn @
  return
