class @TopPanel extends React.Component
  constructor: ->
    @state =
      current_user: UserStore.get()

  onChangeCurrentUser: =>
    @setState current_user: UserStore.get()

  componentWillMount: ->
    UserStore.addChangeListener(@onChangeCurrentUser)

  componentWillUnmount: ->
    UserStore.removeChangeListener(@onChangeCurrentUser)

  renderRegister: ->
    return null if @state.current_user.id?
    <div className='uk-width-medium-1-3 register-link-button'>
      <a href={new_user_registration_path()} className='uk-button-primary uk-button-large'>登録</a>
    </div>

  render: ->
    <div className='uk-block uk-block-secondary uk-contrast uk-block-large'>
      <div className='uk-container'>
        <h1>
          ☆12参考表(地力表)支援サイト
          <image src={image_path('letsencrypt-logo.png')} style={height: '40px'} />
        </h1>
        <div className='uk-grid uk-grid-match' data-uk-grid-margin=''>
          <div className='uk-width-medium-1-3'>2chスレッドで議論された地力表を反映</div>
          <div className='uk-width-medium-1-3'>IRTによる地力値を用いた参考表コンテンツ</div>
          <div className='uk-width-medium-1-3'>クリアランプ管理をグラフで可視化</div>
          <div className='uk-width-medium-1-3' />
          {@renderRegister()}
        </div>
      </div>
    </div>
