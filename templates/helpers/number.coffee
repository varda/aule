module.exports = (number, options) ->
  number.toFixed options.hash.decimals ? 2
