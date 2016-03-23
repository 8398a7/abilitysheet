class @LampStatistics extends React.Component
  constructor: (props) ->
    super
    @state =
      threshold: if props.type is 'clear' then 4 else 2
      statistics: { fc: 0, exh: 0, h: 0, c: 0, e: 0, a: 0, f: 0, n: 0, remain: 0, all: 0 }
      keyValue: ['fc', 'exh', 'h', 'c', 'e', 'a', 'f', 'n']
      viewport: EnvironmentStore.findBy 'viewport'

  onChangeViewPort: =>
    @setState viewport: EnvironmentStore.findBy 'viewport'

  onChangeScore: =>
    statistics = { fc: 0, exh: 0, h: 0, c: 0, e: 0, a: 0, f: 0, n: 0, remain: 0, all: 0 }

    scores = ScoreStore.get()
    for id, _ of SheetStore.get()
      score = scores[id]
      score ||= {}
      score.display ||= ''
      score.state ||= 7
      continue if score.display isnt ''
      statistics.all++
      statistics.remain++ if score.state <= @state.threshold
      statistics[@state.keyValue[score.state]]++
    @setState statistics: statistics

  componentWillMount: ->
    ScoreStore.addChangeListener @onChangeScore
    EnvironmentStore.addChangeListener @onChangeViewPort

  componentWillUnmount: ->
    ScoreStore.removeChangeListener @onChangeScore
    EnvironmentStore.removeChangeListener @onChangeViewPort

  renderMobile: ->
    <tbody>
      <tr>
        <td style={backgroundColor: '#ff8c00'}>FC</td>
        <td>{@state.statistics.fc}</td>
        <td style={backgroundColor: '#ffd900'}>EXH</td>
        <td>{@state.statistics.exh}</td>
        <td style={backgroundColor: '#ff6347'}>H</td>
        <td>{@state.statistics.h}</td>
      </tr>
      <tr>
        <td style={backgroundColor: '#afeeee'}>C</td>
        <td>{@state.statistics.c}</td>
        <td style={backgroundColor: '#98fb98'}>E</td>
        <td>{@state.statistics.e}</td>
        <td style={backgroundColor: '#9595ff'}>A</td>
        <td>{@state.statistics.a}</td>
      </tr>
      <tr>
        <td style={backgroundColor: '#c0c0c0'}>F</td>
        <td>{@state.statistics.f}</td>
        <td style={backgroundColor: '#ffffff'}>N</td>
        <td>{@state.statistics.n}</td>
        <td style={backgroundColor: '#7fffd4'}>
          ({@state.statistics.remain}/{@state.statistics.all})
        </td>
      </tr>
    </tbody>

  renderPC: ->
    <tbody>
      <tr>
        <td style={backgroundColor: '#ff8c00'}>FC</td>
        <td>{@state.statistics.fc}</td>
        <td style={backgroundColor: '#ffd900'}>EXH</td>
        <td>{@state.statistics.exh}</td>
        <td style={backgroundColor: '#ff6347'}>H</td>
        <td>{@state.statistics.h}</td>
        <td style={backgroundColor: '#afeeee'}>C</td>
        <td>{@state.statistics.c}</td>
        <td style={backgroundColor: '#98fb98'}>E</td>
        <td>{@state.statistics.e}</td>
        <td style={backgroundColor: '#9595ff'}>A</td>
        <td>{@state.statistics.a}</td>
        <td style={backgroundColor: '#c0c0c0'}>F</td>
        <td>{@state.statistics.f}</td>
        <td style={backgroundColor: '#ffffff'}>N</td>
        <td>{@state.statistics.n}</td>
        <td style={backgroundColor: '#7fffd4'}>({@state.statistics.remain}/{@state.statistics.all})</td>
      </tr>
    </tbody>

  render: ->
    <div className='uk-overflow-container'>
      <table className='uk-table uk-table-bordered' style={align: 'center'}>
      {
        if _ua.Mobile and @state.viewport
          @renderMobile()
        else
          @renderPC()
      }
      </table>
    </div>

LampStatistics.propTypes =
  type: React.PropTypes.string.isRequired
