$ = require 'jquery'

module.exports = (options) ->
  $('#picker .modal-header h3').html options.fn @
  return
