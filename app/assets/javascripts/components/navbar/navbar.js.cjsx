class @Navbar extends React.Component
  constructor: (props) ->

  onChange: =>

  componentDidMount: ->

  render: ->
    <div className='uk-container uk-container-center'>
      <a href={root_path()} className='uk-navbar-brand'>
        <span className='brand bold'>☆12参考表</span>
      </a>
      <ul className='uk-navbar-nav uk-hidden-small'>
        <li>
          <a href={users_path()}>
            <i className='fa fa-refresh' />
            最近更新したユーザ
          </a>
        </li>
        <MyPage current_user={@props.current_user} recent={@props.recent} />
        <Rival current_user={@props.current_user} />
        <Irt />
        <Conntact />
        <Admin current_user={@props.current_user} />
        <Message current_user={@props.current_user} message={@props.message} />
      </ul>
      <div className='uk-navbar-flip uk-hidden-small'>
        <User current_user={@props.current_user} />
      </div>
      <div className='uk-navbar-flip uk-visible-small'>
        <a className='uk-navbar-toggle' href='#navbar-offcanvas' data-uk-offcanvas=''></a>
      </div>
    </div>

Navbar.displayName = 'Navbar'
Navbar.propTypes =
  current_user: React.PropTypes.object
  recent: React.PropTypes.string
  message: React.PropTypes.number.isRequired
