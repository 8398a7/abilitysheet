class UserProfile extends React.Component {
  constructor(props) {
    super()
    this.state = {
      currentUser: UserStore.get(),
      user: props.user,
      viewport: EnvironmentStore.findBy('viewport')
    }
    this.onChangeViewPort = this.onChangeViewPort.bind(this)
    this.onChangeCurrentUser = this.onChangeCurrentUser.bind(this)
  }

  onChangeViewPort() {
    this.setState({viewport: EnvironmentStore.findBy('viewport')})
  }

  shouldComponentUpdate(nextProps, nextState) {
    props = !Immutable.is(nextProps, this.props)
    state = !Immutable.is(nextState, this.state)
    return props || state
  }

  onChangeCurrentUser() {
    targetUser = UserStore.getTargetUser()
    if (targetUser.id === undefined) {
      this.setState({currentUser: UserStore.get()})
    } else {
      this.setState({
        currentUser: UserStore.get(),
        user: UserStore.getTargetUser()
      })
    }
  }

  componentWillMount() {
    EnvironmentStore.addChangeListener(this.onChangeViewPort)
    UserStore.addChangeListener(this.onChangeCurrentUser)
    UserActionCreators.getMe()
  }

  componentWillUnmount() {
    EnvironmentStore.removeChangeListener(this.onChangeViewPort)
    UserStore.removeChangeListener(this.onChangeCurrentUser)
  }

  render() {
    return (
      <div className='uk-grid react'>
        <UserProfileLeft user={this.state.user} currentUser={this.state.currentUser} viewport={this.state.viewport} />
        <UserProfileRight user={this.state.user} graphDom={this.props.graphDom} viewport={this.state.viewport} />
      </div>
    )
  }
}

UserProfile.proptypes = {
  user: React.PropTypes.object.isRequired,
  graphDom: React.PropTypes.string.isRequired
}
