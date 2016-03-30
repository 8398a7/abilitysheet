@CheckComponentUpdate = (props, nextProps, state, nextState) ->
  p = !(_.isEqual nextProps, props)
  s = !(_.isEqual nextState, state)
  p || s
