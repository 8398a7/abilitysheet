class User extends React.Component {
  shouldComponentUpdate(nextProps, nextState) { return CheckComponentUpdate(this.props, nextProps, this.state, nextState) }

  userDom() {
    if (this.props.currentUser.id) {
      return (
        <li className='uk-parent' data-uk-dropdown>
          <a><i className='fa fa-user' />{this.props.currentUser.djname}</a>
          <div className='uk-dropdown uk-dropdown-navbar'>
            <ul className='uk-nav uk-nav-navbar'>
              <li><a href={user_path(this.props.currentUser.iidxid)}><i className='fa fa-code' />マイページ</a></li>
              <li><a href={edit_user_registration_path()}><i className='fa fa-pencil' />編集</a></li>
              <li><a rel='nofollow' data-method='delete' href={destroy_user_session_path()}><i className='fa fa-sign-out' />ログアウト</a></li>
            </ul>
          </div>
        </li>
      )
    }
    return (<li><a href={new_user_session_path()}><i className='fa fa-sign-in' />ログイン</a></li>)
  }

  render() {
    return (
      <ul className='uk-navbar-nav edit-user'>
        {this.userDom()}
      </ul>
    )
  }
}

User.propTypes = {
  currentUser: React.PropTypes.object
}
