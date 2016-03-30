class RectangleAdsense extends BaseComponent {
  constructor(props) {
    super()
    this.state = {
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

  renderSecondRectangle() {
    if (_ua.Mobile && this.state.viewport) { return null }
    return (
      <GoogleAdsenseIns
        className='adslot_1'
        style={{display: 'inline-block', marginLeft: '20px'}}
        client={this.props.client}
        slot={this.props.slot2}
      />
    )
  }

  render() {
    return (
      <div className='rectangle-adsense'>
        <p className='center'>sponsored links</p>
        <GoogleAdsenseIns
          style={{display: 'inline-block'}}
          className='adslot_1'
          client={this.props.client}
          slot={this.props.slot}
        />
        {this.renderSecondRectangle()}
      </div>
    )
  }
}

RectangleAdsense.propTypes = {
  client: React.PropTypes.string.isRequired,
  slot: React.PropTypes.string.isRequired,
  slot2: React.PropTypes.string.isRequired
}
