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
      <hr />
      {<GoogleAdsense client='ca-pub-5751776715932993' slot='6704745267' /> if @state.renderAds}
      {<hr /> if @state.renderAds}
      <TwitterContents />
    </div>

WelcomeIndex.propTypes =
  mobile: React.PropTypes.bool.isRequired
