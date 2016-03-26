@CheckComponentUpdate = (props, nextProps, state, nextState) ->
  p = !(JSON.stringify(nextProps) is JSON.stringify(props))
  s = !(JSON.stringify(nextState) is JSON.stringify(state))
  p || s
