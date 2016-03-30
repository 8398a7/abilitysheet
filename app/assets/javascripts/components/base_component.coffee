class @BaseComponent extends React.Component
  shouldComponentUpdate: (nextProps, nextState) -> CheckComponentUpdate(@props, nextProps, @state, nextState)
