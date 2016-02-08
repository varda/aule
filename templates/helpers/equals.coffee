module.exports = (left, right, options) ->
  if left is right
    options.fn @
  else
    options.inverse @
