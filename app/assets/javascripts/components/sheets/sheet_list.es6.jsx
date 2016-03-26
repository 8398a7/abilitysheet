class SheetList extends React.Component {
  constructor(props) {
    super()
    this.state = {
      sheets: SheetStore.get(),
      scores: ScoreStore.get(),
      displaySelect: '',
      renderAds: UserStore.renderAds(),
      viewport: EnvironmentStore.findBy('viewport'),
      reverse: EnvironmentStore.findBy('reverseSheet'),
      currentUser: UserStore.get()
    }
    this.onChangeViewPortAndReverse = this.onChangeViewPortAndReverse.bind(this)
    this.onChangeCurrentUser = this.onChangeCurrentUser.bind(this)
    this.onChangeSheet = this.onChangeSheet.bind(this)
    this.onChangeScore = this.onChangeScore.bind(this)
    this.onClickSelect = this.onClickSelect.bind(this)
  }

  shouldComponentUpdate(nextProps, nextState) { return CheckComponentUpdate(this.props, nextProps, this.state, nextState) }

  onChangeViewPortAndReverse() {
    this.setState({
      viewport: EnvironmentStore.findBy('viewport'),
      reverse: EnvironmentStore.findBy('reverseSheet')
    })
  }

  onChangeCurrentUser() {
    this.setState({
      renderAds: UserStore.renderAds(),
      currentUser: UserStore.get()
    })
  }

  onChangeSheet() {
    this.setState({sheets: SheetStore.get()})
  }

  onChangeScore() {
    this.setState({scores: ScoreStore.get()})
  }

  componentWillMount() {
    SheetStore.addChangeListener(this.onChangeSheet)
    ScoreStore.addChangeListener(this.onChangeScore)
    UserStore.addChangeListener(this.onChangeCurrentUser)
    EnvironmentStore.addChangeListener(this.onChangeViewPortAndReverse)
  }

  componentWillUnmount() {
    SheetStore.removeChangeListener(this.onChangeSheet)
    ScoreStore.removeChangeListener(this.onChangeScore)
    UserStore.removeChangeListener(this.onChangeCurrentUser)
    EnvironmentStore.removeChangeListener(this.onChangeViewPortAndReverse)
  }

  classificationSheet() {
    sheets = {}
    Object.keys(this.state.sheets).forEach(id => {
      sheet = this.state.sheets[id]
      if(!sheets[sheet[this.props.type]]) { sheets[sheet[this.props.type]] = {} }
      sheets[sheet[this.props.type]][id] = sheet
      sheets[sheet[this.props.type]].string = sheet[this.props.type + '_string']
      sheets[sheet[this.props.type]][id].id = parseInt(id)
    })
    return sheets
  }

  setAbilities(sheets) {
    abilities = Object.keys(sheets).map((ability) => { return parseInt(ability)})
    if(this.state.reverse) { abilities = abilities.reverse() }
    return abilities
  }

  renderSheet() {
    sheets = this.classificationSheet()
    abilities = this.setAbilities(sheets)

    dom = []
    abilities.forEach(ability => {
      objects = sheets[ability]
      dom.push(<tr key={this.props.type + '_' + ability}>
          <th colSpan={5} style={{textAlign: 'center', backgroundColor: '#f5deb3'}}>{objects.string}</th>
        </tr>)
      delete objects.string
      keys = Object.sortedKeys(objects, 'title', 'asc')
      keys.chunk(5).forEach(array => {
        count = 0
        dom.push(<tr key={array[count]}>
            <LampTd width={150} height={50} iidxid={this.props.user.iidxid} scores={this.state.scores} display={this.state.displaySelect} objects={objects} index={array[count++]} />
            <LampTd width={150} height={50} iidxid={this.props.user.iidxid} scores={this.state.scores} display={this.state.displaySelect} objects={objects} index={array[count++]} />
            <LampTd width={150} height={50} iidxid={this.props.user.iidxid} scores={this.state.scores} display={this.state.displaySelect} objects={objects} index={array[count++]} />
            <LampTd width={150} height={50} iidxid={this.props.user.iidxid} scores={this.state.scores} display={this.state.displaySelect} objects={objects} index={array[count++]} />
            <LampTd width={150} height={50} iidxid={this.props.user.iidxid} scores={this.state.scores} display={this.state.displaySelect} objects={objects} index={array[count++]} />
          </tr>)
      })
    })
    return dom
  }

  onClickSelect() {
    this.setState({displaySelect: this.state.displaySelect === '' ? 'none' : ''})
  }

  renderMobileSheet() {
    sheets = this.classificationSheet()
    abilities = this.setAbilities(sheets)

    dom = []
    abilities.forEach(ability => {
      objects = sheets[ability]
      dom.push(<tr key={this.props.type + '_' + ability}>
          <th style={{textAlign: 'center', backgroundColor: '#f5deb3'}}>{objects.string}</th>
        </tr>)
      delete objects.string
      Object.sortedKeys(objects, 'title', 'asc').forEach(key => {
        dom.push(<tr key={key}>
            <LampTd iidxid={this.props.user.iidxid} scores={this.state.scores} display={this.state.displaySelect} objects={objects} index={key} />
          </tr>)
      })
    })
    return dom
  }

  render() {
    return (
      <div>
        {
          this.state.renderAds ?
            <RectangleAdsense
              client='ca-pub-5751776715932993'
              slot='4549839260'
              slot2='3454772069'
              mobile={false}
            /> : null
        }
        {this.state.renderAds ? <hr style={{margin: '10px 0'}} /> : null}
        {this.state.currentUser.iidxid === this.props.user.iidxid ? <button onClick={this.onClickSelect} className='uk-button uk-button-primary'>編集ボタン表示切替</button> : null}
        <table className='uk-table uk-table-bordered'>
          <tbody>
            {_ua.Mobile && this.state.viewport ? this.renderMobileSheet() : this.renderSheet()}
          </tbody>
        </table>
      </div>
    )
  }
}

SheetList.propTypes = {
  type: React.PropTypes.string.isRequired,
  user: React.PropTypes.object.isRequired
}
