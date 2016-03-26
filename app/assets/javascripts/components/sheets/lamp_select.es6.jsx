class LampSelect extends React.Component {
  constructor(props) {
    super()
  }

  onChangeLamp(e, sheetId) {
    ScoreActionCreators.update({sheetId: sheetId, state: e.target.value, iidxid: this.props.iidxid})
  }

  render() {
    return (
      <form className='uk-form'>
        <select id={'select_' + this.props.sheetId}
          onChange={(e) => this.onChangeLamp(e, this.props.sheetId)}
          style={{display: this.props.display, backgroundColor: this.props.score ? this.props.score.color : ''}}
          value={this.props.score ? this.props.score.state : 7}
        >
          <option value={0}>FC</option>
          <option value={1}>EXH</option>
          <option value={2}>H</option>
          <option value={3}>C</option>
          <option value={4}>E</option>
          <option value={5}>A</option>
          <option value={6}>F</option>
          <option value={7}>N</option>
        </select>
      </form>
    )
  }
}

LampSelect.propTypes = {
  sheetId: React.PropTypes.number.isRequired,
  score: React.PropTypes.object,
  display: React.PropTypes.string.isRequired,
  iidxid: React.PropTypes.string.isRequired
}
