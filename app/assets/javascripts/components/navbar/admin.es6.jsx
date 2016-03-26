class Admin extends React.Component {
  render() {
    if (!this.props.currentUser.id) { return null }
    let role = this.props.currentUser.role
    if (role < 50) { return null }
    return (
      <li className='uk-parent admin-parent' data-uk-dropdown=''>
        <a><i className='fa fa-gears' />管理</a>
        <div className='uk-dropdown uk-dropdown-navbar'>
          <ul className='uk-nav uk-nav-navbar admin-nav'>
            <li><a href={admin_sheets_path()}>楽曲管理</a></li>
            {75 <= role ? <li><a href={admin_users_path()}>ユーザ管理</a></li> : null}
            {75 <= role ? <li><a href={admin_messages_path()}>メッセージ管理</a></li> : null}
            {75 <= role ? <li><a href={new_admin_mail_path()}>問い合わせ返信</a></li> : null}
            {75 <= role ? <li><a href={admin_sidekiq_index_path()}>sidekiq管理</a></li> : null}
            {75 <= role ? <li><a href={'/admin/model'}>RailsAdmin</a></li> : null}
            {100 <= role ? <li><a href={admin_dashboards_path()}>Dashboard</a></li> : null}
          </ul>
        </div>
      </li>
    )
  }
}

Admin.propTypes = {
  currentUser: React.PropTypes.object
}
