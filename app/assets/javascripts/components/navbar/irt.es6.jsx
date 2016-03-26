class Irt extends React.Component {
  shouldComponentUpdate(nextProps, nextState) {
    props = !Immutable.is(nextProps, this.props)
    state = !Immutable.is(nextState, this.state)
    return props || state
  }

  render() {
    return (
      <li>
        <a href={recommends_path()}><i className='fa fa-level-up' />地力値表</a>
      </li>
    )
  }
}
