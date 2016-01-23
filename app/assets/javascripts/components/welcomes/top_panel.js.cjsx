class @TopPanel extends React.Component
  constructor: (props) ->
    super
    @state =
      current_user: UserStore.get()
      title: '☆12参考表(地力表)支援サイト'
      one: '掲示板で議論された地力表を自分のランプで反映'
      two: '地力値を用いて楽曲の難しさを数値化'
      three: 'ランプの遷移をグラフで可視化'

  onChangeCurrentUser: =>
    @setState current_user: UserStore.get()

  componentWillMount: ->
    @mobileContent() if @props.mobile
    UserStore.addChangeListener(@onChangeCurrentUser)

  componentWillUnmount: ->
    UserStore.removeChangeListener(@onChangeCurrentUser)

  mobileContent: ->
    @setState
      title: '☆12参考表'
      one: '掲示板で議論された地力表を反映'
      two: '地力値を用いた楽曲難易度'
      three: 'ランプ遷移をグラフで可視化'

  renderRegister: ->
    return null if @state.current_user.id?
    <div className='uk-width-medium-1-3 register-link-button'>
      <a href={new_user_registration_path()} className='uk-button-primary uk-button-large'>登録</a>
    </div>

  render: ->
    <div className='uk-block uk-contrast uk-block-large top-panel'>
      <div className='uk-container'>
        <h1>{@state.title}</h1>
        <div className='uk-grid uk-grid-match' data-uk-grid-margin=''>
          <div className='uk-width-medium-1-3'>{@state.one}</div>
          <div className='uk-width-medium-1-3'>{@state.two}</div>
          <div className='uk-width-medium-1-3'>{@state.three}</div>
          <div className='uk-width-medium-1-3' />
          {@renderRegister()}
        </div>
      </div>
    </div>

TopPanel.propTypes =
  mobile: React.PropTypes.bool.isRequired
