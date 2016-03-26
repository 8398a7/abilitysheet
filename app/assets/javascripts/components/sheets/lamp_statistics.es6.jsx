class LampStatistics extends React.Component {
  constructor(props) {
    super()
    this.state = {
      threshold: props.type === 'clear' ? 4 : 2,
      statistics: { fc: 0, exh: 0, h: 0, c: 0, e: 0, a: 0, f: 0, n: 0, remain: 0, all: 0 },
      keyValue: ['fc', 'exh', 'h', 'c', 'e', 'a', 'f', 'n'],
      viewport: EnvironmentStore.findBy('viewport')
    }
    this.onChangeViewPort = this.onChangeViewPort.bind(this)
    this.onChangeScore = this.onChangeScore.bind(this)
  }

  onChangeViewPort() {
    this.setState({viewport: EnvironmentStore.findBy('viewport')})
  }

  onChangeScore() {
    statistics = { fc: 0, exh: 0, h: 0, c: 0, e: 0, a: 0, f: 0, n: 0, remain: 0, all: 0 }

    scores = ScoreStore.get()
    Object.keys(SheetStore.get()).forEach(id => {
      score = scores[id]
      if (score === undefined) {
        score = {
          display: '',
          state: 7
        }
      }
      if (score.display !== '') { return null }
      statistics.all++
      if (score.state <= this.state.threshold) { statistics.remain++ }
      statistics[this.state.keyValue[score.state]]++
    })
    this.setState({statistics: statistics})
  }

  componentWillMount() {
    ScoreStore.addChangeListener(this.onChangeScore)
    EnvironmentStore.addChangeListener(this.onChangeViewPort)
  }

  componentWillUnmount() {
    ScoreStore.removeChangeListener(this.onChangeScore)
    EnvironmentStore.removeChangeListener(this.onChangeViewPort)
  }

  renderMobile() {
    return (
      <tbody>
        <tr>
          <td style={{backgroundColor: '#ff8c00'}}>FC</td>
          <td>{this.state.statistics.fc}</td>
          <td style={{backgroundColor: '#ffd900'}}>EXH</td>
          <td>{this.state.statistics.exh}</td>
          <td style={{backgroundColor: '#ff6347'}}>H</td>
          <td>{this.state.statistics.h}</td>
        </tr>
        <tr>
          <td style={{backgroundColor: '#afeeee'}}>C</td>
          <td>{this.state.statistics.c}</td>
          <td style={{backgroundColor: '#98fb98'}}>E</td>
          <td>{this.state.statistics.e}</td>
          <td style={{backgroundColor: '#9595ff'}}>A</td>
          <td>{this.state.statistics.a}</td>
        </tr>
        <tr>
          <td style={{backgroundColor: '#c0c0c0'}}>F</td>
          <td>{this.state.statistics.f}</td>
          <td style={{backgroundColor: '#ffffff'}}>N</td>
          <td>{this.state.statistics.n}</td>
          <td style={{backgroundColor: '#7fffd4'}}>
            ({this.state.statistics.remain}/{this.state.statistics.all})
          </td>
        </tr>
      </tbody>
    )
  }

  renderPC() {
    return (
      <tbody>
        <tr>
          <td style={{backgroundColor: '#ff8c00'}}>FC</td>
          <td>{this.state.statistics.fc}</td>
          <td style={{backgroundColor: '#ffd900'}}>EXH</td>
          <td>{this.state.statistics.exh}</td>
          <td style={{backgroundColor: '#ff6347'}}>H</td>
          <td>{this.state.statistics.h}</td>
          <td style={{backgroundColor: '#afeeee'}}>C</td>
          <td>{this.state.statistics.c}</td>
          <td style={{backgroundColor: '#98fb98'}}>E</td>
          <td>{this.state.statistics.e}</td>
          <td style={{backgroundColor: '#9595ff'}}>A</td>
          <td>{this.state.statistics.a}</td>
          <td style={{backgroundColor: '#c0c0c0'}}>F</td>
          <td>{this.state.statistics.f}</td>
          <td style={{backgroundColor: '#ffffff'}}>N</td>
          <td>{this.state.statistics.n}</td>
          <td style={{backgroundColor: '#7fffd4'}}>({this.state.statistics.remain}/{this.state.statistics.all})</td>
        </tr>
      </tbody>
    )
  }

  render() {
    return (
      <div className='uk-overflow-container'>
        <table className='uk-table uk-table-bordered' style={{align: 'center'}}>
        {_ua.Mobile && this.state.viewport ? this.renderMobile() : this.renderPC()}
        </table>
      </div>
    )
  }
}

LampStatistics.propTypes = {
  type: React.PropTypes.string.isRequired
}
