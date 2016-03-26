class ScreenShot extends React.Component {
  constructor(props) {
    super()
    this.state = {
      capture: false,
      download: false,
      dataUrl: '#',
      text: 'スクリーンショット'
    }
    this.onClick = this.onClick.bind(this)
  }

  shouldComponentUpdate(nextProps, nextState) { return CheckComponentUpdate(this.props, nextProps, this.state, nextState) }

  onClick() {
    if (this.state.capture) { return null }
    this.setState({text: '保存中...'})
    $('.google-adsense').hide()
    html2canvas(document.body, {
      onrendered: (canvas) => {
        this.setState({
          text: 'ダウンロード',
          capture: true,
          download: 'ss.png',
          dataUrl: canvas.toDataURL('image/png')
        })
        $('.google-adsense').show()
      }
    })
  }

  render() {
    return (
      <a className='uk-button react' download={this.state.download} id='ss' href={this.state.dataUrl} onClick={this.onClick}>
        <i className='fa fa-camera' />
        {this.state.text}
      </a>
    )
  }
}
