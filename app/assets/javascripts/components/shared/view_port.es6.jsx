class ViewPort extends React.Component {
  constructor(props) {
    super()
    this.state = {
      viewport: EnvironmentStore.findBy('viewport')
    }
    this.onChangeViewPort = this.onChangeViewPort.bind(this)
  }

  onChangeViewPort() {
    this.setState({
      viewport: EnvironmentStore.findBy('viewport')
    })
  }

  componentWillMount() {
    EnvironmentStore.addChangeListener(this.onChangeViewPort)
  }

  componentWillUnmount() {
    EnvironmentStore.removeChangeListener(this.onChangeViewPort)
  }

  render() {
    if (!this.state.viewport) {
      return (<meta name='viewport' />)
    }
    return (<meta name='viewport' content='width=device-width, initial-scale=1' />)
  }
}
