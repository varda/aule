$ = require 'jquery'
URI = require 'urijs'

module.exports = ->
  [base, segments..., {hash: query}] = arguments
  segments
    .reduce ((uri, segment) -> uri.segmentCoded segment), URI base
    .setQuery query
    .toString()
