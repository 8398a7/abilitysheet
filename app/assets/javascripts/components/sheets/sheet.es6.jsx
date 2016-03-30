class Sheet extends BaseComponent {
  constructor(props) {
    super()
    this.state = {
      type: {
        clear: {
          name: 'ノマゲ参考表',
          remain: '未クリア',
          link: 'hard',
          button: 'uk-button-danger'
        },
        hard: {
          name: 'ハード参考表',
          link: 'clear',
          remain: '未難',
          button: 'uk-button-primary'
        }
      },
      remain: false,
      viewport: EnvironmentStore.findBy('viewport')
    }
    this.onClickViewPort = this.onClickViewPort.bind(this)
    this.onChangeScore = this.onChangeScore.bind(this)
    this.onChangeViewPort = this.onChangeViewPort.bind(this)
  }

  onClickViewPort() {
    params = getQueryParams(location.search)
    let url = location.origin + location.pathname
    // parameterの付与/削除
    this.state.viewport === true ? params.device = 'pc' : delete params.device
    history.replaceState('', '', mergeQueryParams(url, params))
    EnvironmentActionCreators.changeViewport(!this.state.viewport)
  }

  onChangeScore() {
    this.setState({remain: ScoreStore.remain(this.props.type)})
  }

  onChangeViewPort() {
    this.setState({viewport: EnvironmentStore.findBy('viewport')})
  }

  componentWillMount() {
    SheetActionCreators.get()
    EnvironmentActionCreators.judgeReverse()
    ScoreActionCreators.get({iidxid: this.props.user.iidxid})
    ScoreStore.addChangeListener(this.onChangeScore)
    EnvironmentStore.addChangeListener(this.onChangeViewPort)
  }

  componentWillUnmount() {
    ScoreStore.removeChangeListener(this.onChangeScore)
    EnvironmentStore.removeChangeListener(this.onChangeViewPort)
  }

  renderSwitchViewPort() {
    return (
      <button className='uk-button' onClick={this.onClickViewPort}>
        <i className='fa fa-refresh' />
        {this.state.viewport === true ? 'PCサイト版' : 'モバイル版'}
      </button>
    )
  }

  render() {
    return (
      <div className='react'>
        <SheetModal />
        <div className='center'>
          <h2>
            <i className='fa fa-table' />
            {this.state.type[this.props.type].name}
            ({this.state.type[this.props.type].remain}{this.state.remain})
          </h2>
          <h3>
            <a href={user_path(this.props.user.iidxid)}>{'DJ.' + this.props.user.djname + '(' + this.props.user.iidxid + ')'}</a>
          </h3>
          {
            this.state.remain !== false ?
              <TwitterSharedButton text={'DJ.' + this.props.user.djname + ' ☆12' + this.state.type[this.props.type].name + '(' + this.state.type[this.props.type].remain + this.state.remain + ')'} /> : null
          }
          <ScreenShot />
          <a className={'uk-button ' + this.state.type[this.props.type].button} href={sheet_path({iidxid: this.props.user.iidxid, type: this.state.type[this.props.type].link})}>
            {this.state.type[this.props.type].link.toUpperCase()}
          </a>
          {_ua.Mobile ? this.renderSwitchViewPort() : null}
          <hr />
          <Checkbox versions={this.props.versions} sheetType={this.props.sheetType} lamp={this.props.lamp} />
          <LampStatistics type={this.props.type} />
          <h3 />
          <SheetList type={this.props.type} user={this.props.user} />
        </div>
      </div>
    )
  }
}

Sheet.propTypes = {
  type: React.PropTypes.string.isRequired,
  user: React.PropTypes.object.isRequired
}
