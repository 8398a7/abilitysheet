class @RectangleAdsense extends React.Component
  constructor: (props) ->
    super
    @state =
      viewport: EnvironmentStore.findBy 'viewport'

  onChangeViewPort: =>
    @setState viewport: EnvironmentStore.findBy 'viewport'

  componentWillMount: ->
    EnvironmentStore.addChangeListener @onChangeViewPort

  componentWillUnmount: ->
    EnvironmentStore.removeChangeListener @onChangeViewPort

  renderSecondRectangle: ->
    return null if _ua.Mobile and @state.viewport
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
  client: React.PropTypes.string.isRequired
  slot: React.PropTypes.string.isRequired
  slot2: React.PropTypes.string.isRequired
