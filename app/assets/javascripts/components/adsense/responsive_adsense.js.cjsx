class @ResponsiveAdsense extends React.Component
  constructor: (props) ->
    super

  componentDidMount: ->
    (adsbygoogle = window.adsbygoogle || []).push {}

  render: ->
    <div className='google-adsense'>
      <p className='center'>sponsored links</p>
      <GoogleAdsenseIns
        client={@props.client}
        slot={@props.slot}
        className='center'
        style={display: 'block'}
        format='auto'
      />
    </div>

ResponsiveAdsense.propTypes =
  client: React.PropTypes.string.isRequired
  slot: React.PropTypes.string.isRequired
