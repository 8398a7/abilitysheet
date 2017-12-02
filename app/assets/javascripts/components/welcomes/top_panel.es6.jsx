class TopPanel extends BaseComponent {
  constructor(props) {
    super()
    this.state = {
      currentUser: UserStore.get(),
      title: 'SP☆12参考表(地力表)支援サイト',
      one: '掲示板で議論された地力表を自分のランプで反映',
      two: '地力値を用いて楽曲の難しさを数値化',
      three: 'ランプの遷移をグラフで可視化'
    }
    this.onChangeCurrentUser = this.onChangeCurrentUser.bind(this)
  }

  onChangeCurrentUser() {
    this.setState({
      currentUser: UserStore.get()
    })
  }

  componentWillMount() {
    if (_ua.Mobile && this.props.viewport) {
      this.mobileContent()
    }
    UserStore.addChangeListener(this.onChangeCurrentUser)
  }

  componentWillUnmount() {
    UserStore.removeChangeListener(this.onChangeCurrentUser)
  }

  mobileContent() {
    this.setState({
      title: 'SP☆12参考表',
      one: '掲示板で議論された地力表を反映',
      two: '地力値を用いた楽曲難易度',
      three: 'ランプ遷移をグラフで可視化'
    })
  }

  renderRegister() {
    if (this.state.currentUser.id) {
      return null
    }
    return (
      <div className='uk-width-medium-1-3 register-link-button'>
        <a href={new_user_registration_path()} className='uk-button-primary uk-button-large'>登録</a>
      </div>
    )
  }

  render() {
    return (
      <div className='uk-block uk-contrast uk-block-large top-panel'>
        <div className='uk-container'>
          <h1>{this.state.title}</h1>
          <div className='uk-grid uk-grid-match' data-uk-grid-margin>
            <div className='uk-width-medium-1-3'>{this.state.one}</div>
            <div className='uk-width-medium-1-3'>{this.state.two}</div>
            <div className='uk-width-medium-1-3'>{this.state.three}</div>
            <div className='uk-width-medium-1-3' />
            {this.renderRegister()}
          </div>
        </div>
      </div>
    )
  }
}

TopPanel.propTypes = {
  viewport: PropTypes.bool.isRequired
}
