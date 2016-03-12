class @Footer extends React.Component
  constructor: ->
    @state =
      renderAds: UserStore.renderAds()

  onChangeCurrentUser: =>
    @setState renderAds: UserStore.renderAds()

  componentWillMount: ->
    UserStore.addChangeListener @onChangeCurrentUser

  componentWillUnmount: ->
    UserStore.removeChangeListener @onChangeCurrentUser

  render: ->
    now = new Date()
    year = now.getFullYear()
    <div className='footer'>
      {
        <RectangleAdsense
          client='ca-pub-5751776715932993'
          slot='9876188066'
          slot2='6503919265'
        /> if @state.renderAds
      }
      <div className='relative'>
        <div className='uk-panel panel-default'>
          <span className='left-position'>
            <a href='http://twitter.com/IIDX_12'>
              <i className='fa fa-twitter' />
              Twitter
            </a>
          </span>
          <span>&copy; IIDX☆12参考表 8398a7 2014-{year} <a href='https://github.com/8398a7/abilitysheet' target='_blank'><i className='fa fa-github' /></a></span>
        </div>
      </div>
    </div>
