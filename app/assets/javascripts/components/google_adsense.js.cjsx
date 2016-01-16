class @GoogleAdsense extends React.Component
  constructor: (props) ->
    super

  componentDidMount: ->
    (adsbygoogle = window.adsbygoogle || []).push {}

  render: ->
    <div className='google-adsense'>
      <p className='center'>sponsored links</p>
      <ins
        className='adsbygoogle center'
        style={display: 'block', backgroundColor: 'white'}
        data-ad-client={@props.client}
        data-ad-slot={@props.slot}
        data-ad-format='auto'
      />
    </div>

GoogleAdsense.propTypes =
  client: React.PropTypes.string.isRequired
  slot: React.PropTypes.string.isRequired
