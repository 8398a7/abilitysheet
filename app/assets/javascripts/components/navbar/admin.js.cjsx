class @Admin extends React.Component
  render: ->
    return null if @props.current_user? and @props.current_user.unmount?
    return null unless @props.current_user?
    role = @props.current_user.role
    return null if role < 50
    <li className='uk-parent admin-parent' data-uk-dropdown=''>
      <a><i className='fa fa-gears' />管理</a>
      <div className='uk-dropdown uk-dropdown-navbar'>
        <ul className='uk-nav uk-nav-navbar admin-nav'>
          <li><a href={admin_sheets_path()}>楽曲管理</a></li>
          {<li><a href={admin_users_path()}>ユーザ管理</a></li> if 75 <= role}
          {<li><a href={admin_messages_path()}>メッセージ管理</a></li> if 75 <= role}
          {<li><a href={new_admin_mail_path()}>問い合わせ返信</a></li> if 75 <= role}
          {<li><a href={admin_sidekiq_index_path()}>sidekiq管理</a></li> if 75 <= role}
          {<li><a href={'/admin/model'}>RailsAdmin</a></li> if 75 <= role}
          {<li><a href={new_admin_tweet_path()}>Twitter</a></li> if role is 100}
          {<li><a href={admin_dashboards_path()}>Dashboard</a></li> if role is 100}
        </ul>
      </div>
    </li>

Admin.displayName = 'Admin'
Admin.propTypes =
  current_user: React.PropTypes.object
