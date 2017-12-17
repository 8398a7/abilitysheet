class UserProfile extends BaseComponent {
  constructor(props) {
    super(props)
    this.state = {
      user: props.user,
      viewport: EnvironmentStore.findBy('viewport')
    }
    this.onChangeViewPort = this.onChangeViewPort.bind(this)
  }

  onChangeViewPort() {
    this.setState({viewport: EnvironmentStore.findBy('viewport')})
  }

  componentWillMount() {
    EnvironmentStore.addChangeListener(this.onChangeViewPort)
  }

  componentWillUnmount() {
    EnvironmentStore.removeChangeListener(this.onChangeViewPort)
  }

  render() {
    return (
      <div>
        <CalHeatmap user={this.state.user} viewport={this.state.viewport} />
        <SplineGraph initialRender={false} iidxid={this.state.user.iidxid} />
      </div>
    )
  }
}

UserProfile.proptypes = {
  user: PropTypes.object.isRequired,
  graphDom: PropTypes.string.isRequired
}
