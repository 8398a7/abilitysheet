class @LampSelect extends React.Component
  constructor: (props) ->
    super

  onChangeLamp: (e, sheetId) ->
    ScoreActionCreators.update sheetId: sheetId, state: e.target.value, iidxid: @props.iidxid

  render: ->
    return null unless @props.score
    <form className='uk-form'>
      <select
        onChange={(e) => @onChangeLamp e, @props.score.sheetId}
        style={display: @props.display, backgroundColor: @props.score.color}
        defaultValue={@props.score.state}
      >
        <option value=0>FC</option>
        <option value=1>EXH</option>
        <option value=2>H</option>
        <option value=3>C</option>
        <option value=4>E</option>
        <option value=5>A</option>
        <option value=6>F</option>
        <option value=7>N</option>
      </select>
    </form>

LampSelect.propTypes =
  score: React.PropTypes.object
  display: React.PropTypes.string.isRequired
  iidxid: React.PropTypes.string.isRequired
