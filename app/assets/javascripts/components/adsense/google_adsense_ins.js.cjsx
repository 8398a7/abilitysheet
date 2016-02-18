class @GoogleAdsenseIns extends React.Component
  constructor: (props) ->
    super

  render: ->
    <ins
      className={'adsbygoogle ' + @props.className}
      style={@props.style}
      data-ad-client={@props.client}
      data-ad-slot={@props.slot}
      data-ad-format={@props.format}
    />

GoogleAdsenseIns.propTypes =
  client: React.PropTypes.string.isRequired
  slot: React.PropTypes.string.isRequired
  className: React.PropTypes.string.isRequired
  style: React.PropTypes.object.isRequired
  format: React.PropTypes.string
      # style={display: 'block', backgroundColor: 'white'}
