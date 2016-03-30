class LampSelect extends BaseComponent {
  onChangeLamp(e, sheetId) {
    ScoreActionCreators.update({sheetId: sheetId, state: e.target.value, iidxid: this.props.iidxid})
  }

  render() {
    return (
      <form className='uk-form'>
        <select id={`select_${this.props.sheetId}`}
          onChange={(e) => this.onChangeLamp(e, this.props.sheetId)}
          style={{display: this.props.display, backgroundColor: this.props.score ? this.props.score.color : ''}}
          value={this.props.score ? this.props.score.state : Env.NOPLAY}
        >
          <option value={Env.FC}>FC</option>
          <option value={Env.EXH}>EXH</option>
          <option value={Env.HARD}>H</option>
          <option value={Env.CLEAR}>C</option>
          <option value={Env.EASY}>E</option>
          <option value={Env.ASSIST}>A</option>
          <option value={Env.FAILED}>F</option>
          <option value={Env.NOPLAY}>N</option>
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
