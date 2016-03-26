class WelcomeIndex extends React.Component {
  constructor(props) {
    super()
    this.state = {
      renderAds: UserStore.renderAds(),
      viewport: EnvironmentStore.findBy('viewport')
    }
    this.onChangeViewPort = this.onChangeViewPort.bind(this)
    this.onChangeCurrentUser = this.onChangeCurrentUser.bind(this)
  }

  shouldComponentUpdate(nextProps, nextState) {
    props = !Immutable.is(nextProps, this.props)
    state = !Immutable.is(nextState, this.state)
    return props || state
  }

  onChangeViewPort() {
    this.setState({
      viewport: EnvironmentStore.findBy('viewport')
    })
  }

  onChangeCurrentUser() {
    this.setState({
      renderAds: UserStore.renderAds()
    })
  }

  componentWillMount() {
    EnvironmentStore.addChangeListener(this.onChangeViewPort)
    UserStore.addChangeListener(this.onChangeCurrentUser)
  }

  componentWillUnmount() {
    EnvironmentStore.removeChangeListener(this.onChangeViewPort)
    UserStore.removeChangeListener(this.onChangeCurrentUser)
  }

  render() {
    return (
      <div className='welcome-index'>
        <TopPanel viewport={this.state.viewport} />
        <hr style={{margin: '10px 0'}} />
        {
          this.state.renderAds ?
            <RectangleAdsense
              client='ca-pub-5751776715932993'
              slot='4549839260'
              slot2='3454772069'
            /> : null
        }
        {this.state.renderAds ? <hr style={{margin: '10px 0'}} /> : null}
        <TwitterContents />
        <br />
        <div className='uk-panel uk-panel-box'>
          <h3 className='uk-panel-title'>可視化例</h3>
          <div className='center'>
            <SplineGraph initialRender={true} />
          </div>
        </div>
      </div>
    )
  }
}
