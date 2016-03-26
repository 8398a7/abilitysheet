class Message extends React.Component {
  constructor(props) {
    super()
    this.state = {
      message: null
    }
    this.onChangeMessage = this.onChangeMessage.bind(this)
  }

  shouldComponentUpdate(nextProps, nextState) {
    props = !Immutable.is(nextProps, this.props)
    state = !Immutable.is(nextState, this.state)
    return props || state
  }

  componentDidMount() {
    MessageStore.addChangeListener(this.onChangeMessage)
  }

  componentWillUnmount() {
    MessageStore.removeChangeListener(this.onChangeMessage)
  }

  onChangeMessage() {
    this.setState({message: MessageStore.get()})
  }

  render() {
    if (this.state.message === 0 || this.state.message === null) { return null }
    if (75 <= this.props.currentUser.role && this.state.message === null) { MessageActionCreators.fetch() }
    return (
      <div className='uk-badge uk-badge-notification uk-badge-danger'>
        {this.state.message}
      </div>
    )
  }
}

Message.propTypes = {
  currentUser: React.PropTypes.object
}
