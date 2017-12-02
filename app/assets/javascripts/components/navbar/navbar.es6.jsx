class Navbar extends BaseComponent {
  constructor(props) {
    super()
    this.state = {
      currentUser: UserStore.get()
    }
    this.onChangeCurrentUser = this.onChangeCurrentUser.bind(this)
  }

  onChangeCurrentUser() {
    this.setState({currentUser: UserStore.get()})
  }

  componentWillMount() {
    UserStore.addChangeListener(this.onChangeCurrentUser)
    UserActionCreators.getMe()
    EnvironmentActionCreators.judgeMode()
  }

  componentWillUnmount() {
    UserStore.removeChangeListener(this.onChangeCurrentUser)
  }

  render() {
    return (
      <div className='uk-container uk-container-center react'>
        <a href={root_path()} className='uk-navbar-brand'>
          <img src={image_path('icon.png')} style={{height: '30px'}} />
        </a>
        <ul className='uk-navbar-nav uk-hidden-small'>
          <li>
            <a href={users_path()}>
              <i className='fa fa-refresh' />
              最近更新したユーザ
            </a>
          </li>
          <MyPage currentUser={this.state.currentUser} recent={this.props.recent} />
          <Rival currentUser={this.state.currentUser} />
          <Irt />
          <Conntact />
          <Help />
          <Admin currentUser={this.state.currentUser} />
          <Message currentUser={this.state.currentUser} />
        </ul>
        <div className='uk-navbar-flip uk-hidden-small'>
          <User currentUser={this.state.currentUser} />
        </div>
        <div className='uk-navbar-flip uk-visible-small'>
          <a className='uk-navbar-toggle' href='#navbar-offcanvas' data-uk-offcanvas></a>
        </div>
      </div>
    )
  }
}

Navbar.propTypes = {
  recent: PropTypes.string
}
