class @RectangleAdsense extends React.Component
  constructor: (props) ->
    super

  componentDidMount: ->
    (adsbygoogle = window.adsbygoogle || []).push {}

  renderSecondRectangle: ->
    return null if @props.mobile
    <GoogleAdsenseIns
      className='adslot_1'
      style={display: 'inline-block', marginLeft: '20px'}
      client={@props.client}
      slot={@props.slot2}
    />

  render: ->
    <div className='rectangle-adsense'>
      <p className='center'>sponsored links</p>
      <GoogleAdsenseIns
        style={display: 'inline-block'}
        className='adslot_1'
        client={@props.client}
        slot={@props.slot}
      />
      {@renderSecondRectangle()}
    </div>

RectangleAdsense.propTypes =
  mobile: React.PropTypes.bool.isRequired
  client: React.PropTypes.string.isRequired
  slot: React.PropTypes.string.isRequired
  slot2: React.PropTypes.string.isRequired
