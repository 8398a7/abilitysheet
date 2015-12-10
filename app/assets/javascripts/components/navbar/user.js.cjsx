class @User extends React.Component
  userDom: ->
    unless @props.current_user
      <li><a href={'.' + new_user_session_path()}><i className='fa fa-sign-in' />ログイン</a></li>
    else
      <li className='uk-parent' data-uk-dropdown=''>
        <a><i className='fa fa-user' />{@props.current_user.djname}</a>
        <div className='uk-dropdown uk-dropdown-navbar'>
          <ul className='uk-nav uk-nav-navbar'>
            <li><a href={'.' + edit_user_registration_path()}><i className='fa fa-pencil' />編集</a></li>
            <li><a rel='nofollow' data-method='delete' href={'.' + destroy_user_session_path()}><i className='fa fa-sign-out' />ログアウト</a></li>
          </ul>
        </div>
      </li>

  render: ->
    return null if @props.current_user? and @props.current_user.unmount?
    <ul className='uk-navbar-nav edit-user'>
      {@userDom()}
    </ul>

User.displayName = 'User'
User.propTypes =
  current_user: React.PropTypes.object
