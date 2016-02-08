marked = require 'marked'

module.exports = (text) ->
  marked text, sanitize: true
