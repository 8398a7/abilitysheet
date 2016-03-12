class @WelcomeIndex extends React.Component
  constructor: (props) ->
    super
    @state =
      renderAds: UserStore.renderAds()
      viewport: EnvironmentStore.findBy 'viewport'

  onChangeViewPort: =>
    @setState viewport: EnvironmentStore.findBy 'viewport'

  onChangeCurrentUser: =>
    @setState renderAds: UserStore.renderAds()

  componentWillMount: ->
    EnvironmentStore.addChangeListener @onChangeViewPort
    UserStore.addChangeListener @onChangeCurrentUser

  componentWillUnmount: ->
    EnvironmentStore.removeChangeListener @onChangeViewPort
    UserStore.removeChangeListener @onChangeCurrentUser

  render: ->
    <div className='welcome-index'>
      <TopPanel viewport={@state.viewport} />
      <hr style={margin: '10px 0'} />
      {
        <RectangleAdsense
          client='ca-pub-5751776715932993'
          slot='4549839260'
          slot2='3454772069'
        /> if @state.renderAds
      }
      {<hr style={margin: '10px 0'} /> if @state.renderAds}
        <TwitterContents />
      <br />
      <div className='uk-panel uk-panel-box'>
        <h3 className='uk-panel-title'>可視化例</h3>
        <div className='center'>
          <SplineGraph initialRender=true />
        </div>
      </div>
    </div>
