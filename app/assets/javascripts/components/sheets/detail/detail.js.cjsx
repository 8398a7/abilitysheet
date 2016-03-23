class @Detail extends React.Component
  constructor: (props) ->
    super

  renderDetail: ->
    @props.scores.map (score) ->
      <tr key={score.version}>
        <td style={backgroundColor: Env.color[score.state]}></td>
        <td>{score.score}</td>
        <td>{score.bp}</td>
        <td>{score.version}</td>
      </tr>

  render: ->
    <div className='react'>
      <h2><i className='fa fa-history' />{@props.title}</h2>
      <table className='uk-table uk-table-hover uk-table-striped'>
        <thead>
          <tr>
            <td>state</td>
            <td>score</td>
            <td>bp</td>
            <td>version</td>
          </tr>
        </thead>
        <tbody>
          {@renderDetail()}
        </tbody>
      </table>
    </div>

Detail.propTypes =
  scores: React.PropTypes.array.isRequired
  title: React.PropTypes.string.isRequired
