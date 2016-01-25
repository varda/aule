moment = require 'moment'

module.exports = (date, options) ->
  moment(date).format options.hash.format ? 'MMM Do, YYYY'
