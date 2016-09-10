class UserProfileLeft extends BaseComponent {
  constructor(props) {
    super()
    this.state = {
      grades: StaticStore.get().grade === undefined ? null : StaticStore.get().grade,
      pref: StaticStore.get().pref,
      date: new Date(props.user.createdAt),
      addRival: 'ライバルに追加',
      removeRival: 'ライバルから削除',
      normal: 'ノマゲ参考表',
      hard: 'ハード参考表',
      compareNormal: 'ノマゲ比較',
      compareHard: 'ハード比較'
    }
    this.onChangeGrade = this.onChangeGrade.bind(this)
    this.changeRival = this.changeRival.bind(this)
  }

  componentWillMount() {
    StaticStore.addChangeListener(this.onChangeGrade)
    StaticActionCreators.get()
    this.setGrade()
    if (!(_ua.Mobile && this.props.viewport)) {
      return null
    }
    this.setState({
      addRival: '追加',
      removeRival: '削除',
      normal: 'ノマゲ',
      hard: 'ハード',
      compareNormal: '比較',
      compareHard: '比較'
    })
  }

  componentWillUnmount() {
    StaticStore.removeChangeListener(this.onChangeGrade)
  }

  onChangeGrade() {
    this.setGrade()
  }

  setGrade() {
    if (StaticStore.get().grade === undefined) { return null }
    let grades = StaticStore.get().grade[this.props.user.grade]
    Object.keys(grades).forEach(gradeString => {
      let gradeColor = grades[gradeString]
      this.setState({
        pref: StaticStore.get().pref,
        grades: grades,
        gradeString: gradeString,
        gradeColor: gradeColor
      })
    })
  }

  compareDom() {
    if (this.props.currentUser.id === undefined) { return null }
    if (this.props.currentUser.iidxid === this.props.user.iidxid) { return null }
    return (
      <div>
        <a className='uk-button uk-button-primary' href={clear_rival_path(this.props.user.iidxid)}>{this.state.compareNormal}</a>
        <a className='uk-button uk-button-danger' href={hard_rival_path(this.props.user.iidxid)}>{this.state.compareHard}</a>
      </div>
    )
  }

  changeRival() {
    UserActionCreators.changeRival(this.props.user.iidxid)
  }

  renderRival() {
    if (this.props.currentUser.id === undefined) { return null }
    if (this.props.currentUser.iidxid === this.props.user.iidxid) { return null }
    let dom = this.props.currentUser.follows.indexOf(this.props.user.iidxid) === -1 ?
      <button className='uk-button' onClick={this.changeRival}><i className='fa fa-user-plus' />{this.state.addRival}</button> : <button className='uk-button' onClick={this.changeRival}><i className='fa fa-user-times' />{this.state.removeRival}</button>
    return dom
  }

  render() {
    return (
      <div className='uk-width-3-10'>
        <img className='icon' src={this.props.user.imageUrl} />
        <div style={{marginTop: '20px'}}><h2><b>{this.props.user.djname}</b></h2></div>
        <div><h3>{this.props.user.iidxid}&nbsp;{this.renderRival()}</h3></div>
        <div style={{paddingBottom: '3px'}}>
          <TwitterSharedButton
            text={`DJ.${this.props.user.djname} ☆12参考表プロフィール`}
          />
        </div>
        <div style={{paddingBottom: '3px'}}>
          <a className='uk-button uk-button-primary' href={sheet_path(this.props.user.iidxid, {type: 'clear'})}>{this.state.normal}</a>
          <a className='uk-button uk-button-danger' href={sheet_path(this.props.user.iidxid, {type: 'hard'})}>{this.state.hard}</a>
        </div>
        {this.compareDom()}
        <hr />
        <div><i className='fa fa-street-view' />{this.state.gradeString}</div>
        {this.state.pref ? <div><i className='fa fa-map-marker' />{this.state.pref[this.props.user.pref]}</div> : null}
        <div><i className='fa fa-clock-o' />Joined on {this.state.date.getFullYear()}/{this.state.date.getMonth() + 1}/{this.state.date.getDate()}</div>
        <hr />
        <RivalNumber user={this.props.user} />
      </div>
    )
  }
}

UserProfileLeft.proptypes = {
  user: React.PropTypes.object.isRequired,
  currentUser: React.PropTypes.object,
  viewport: React.PropTypes.bool.isRequired
}
