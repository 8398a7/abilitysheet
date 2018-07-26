class GoogleAdsenseIns extends BaseComponent {
  render() {
    style = $.extend(true, {}, this.props.style)
    style['backgroundColor'] = 'white'
    return (
      <ins
        className={'adsbygoogle ' + this.props.className}
        style={style}
        data-full-width-responsive='true'
        data-ad-client={this.props.client}
        data-ad-slot={this.props.slot}
        data-ad-format={this.props.format}
      />
    )
  }
}

GoogleAdsenseIns.propTypes = {
  client: PropTypes.string.isRequired,
  slot: PropTypes.string.isRequired,
  className: PropTypes.string.isRequired,
  style: PropTypes.object.isRequired,
  format: PropTypes.string
}
