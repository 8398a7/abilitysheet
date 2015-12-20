class @Navbar extends React.Component
  constructor: (props) ->
    @state =
      current_user: { unmount: true }

  onChangeCurrentUser: =>
    @setState current_user: UserStore.get()

  componentWillMount: ->
    UserStore.addChangeListener(@onChangeCurrentUser)
    UserActionCreators.getMe()

  componentWillUnmount: ->
    UserStore.removeChangeListener(@onChangeCurrentUser)

  render: ->
    <div className='uk-container uk-container-center react'>
      <a href={root_path()} className='uk-navbar-brand' data-no-turbolink=true>
        <span className='brand bold'>☆12参考表</span>
      </a>
      <ul className='uk-navbar-nav uk-hidden-small'>
        <li>
          <a href={users_path()}>
            <i className='fa fa-refresh' />
            最近更新したユーザ
          </a>
        </li>
        <MyPage current_user={@state.current_user} recent={@props.recent} />
        <Rival current_user={@state.current_user} />
        <Irt />
        <Conntact />
        <Admin current_user={@state.current_user} />
        <Message current_user={@state.current_user} />
      </ul>
      <div className='uk-navbar-flip uk-hidden-small'>
        <User current_user={@state.current_user} />
      </div>
      <div className='uk-navbar-flip uk-visible-small'>
        <a className='uk-navbar-toggle' href='#navbar-offcanvas' data-uk-offcanvas=''></a>
      </div>
    </div>

Navbar.displayName = 'Navbar'
Navbar.propTypes =
  recent: React.PropTypes.string
