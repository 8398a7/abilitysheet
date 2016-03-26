class GoogleAdsenseIns extends React.Component {
  componentDidMount() {
    this.pushAd()
  }

  componentDidUpdate() {
    try {
      this.pushAd()
    } catch(e) {
    }
  }

  pushAd() {
    (adsbygoogle = window.adsbygoogle || []).push({})
  }

  render() {
    style = $.extend(true, {}, this.props.style)
    style['backgroundColor'] = 'white'
    return (
      <ins
        className={'adsbygoogle ' + this.props.className}
        style={style}
        data-ad-client={this.props.client}
        data-ad-slot={this.props.slot}
        data-ad-format={this.props.format}
      />
    )
  }
}

GoogleAdsenseIns.propTypes = {
  client: React.PropTypes.string.isRequired,
  slot: React.PropTypes.string.isRequired,
  className: React.PropTypes.string.isRequired,
  style: React.PropTypes.object.isRequired,
  format: React.PropTypes.string
}
