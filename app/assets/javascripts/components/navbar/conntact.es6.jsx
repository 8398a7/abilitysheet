class Conntact extends React.Component {
  shouldComponentUpdate(nextProps, nextState) {
    props = !Immutable.is(nextProps, this.props)
    state = !Immutable.is(nextState, this.state)
    return props || state
  }

  render() {
    return (
      <li>
        <a href={new_message_path()}><i className='fa fa-phone' />連絡フォーム</a>
      </li>
    )
  }
}
