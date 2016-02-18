class @WelcomeIndex extends React.Component
  constructor: (props) ->
    super
    @state =
      renderAds: UserStore.renderAds()

  onChangeCurrentUser: =>
    @setState renderAds: UserStore.renderAds()

  componentWillMount: ->
    UserStore.addChangeListener(@onChangeCurrentUser)

  componentWillUnmount: ->
    UserStore.removeChangeListener(@onChangeCurrentUser)

  render: ->
    <div className='welcome-index'>
      <TopPanel mobile={@props.mobile} />
      <hr style={margin: '10px 0'} />
      {
        <RectangleAdsense
          client='ca-pub-5751776715932993'
          slot='4549839260'
          slot2='3454772069'
          mobile={@props.mobile}
        /> if @state.renderAds
      }
      {<hr style={margin: '10px 0'} /> if @state.renderAds}
      <TwitterContents />
    </div>

WelcomeIndex.propTypes =
  mobile: React.PropTypes.bool.isRequired
