class LampCheckbox extends BaseComponent {
  constructor(props) {
    super()
    this.onChangeLamp = this.onChangeLamp.bind(this)
  }

  recChangeLamp(array) {
    $('input[name="check-lamp"]').prop('checked', false);
    array.forEach(num => $('input[id="state-' + num + '"]').prop('checked', true))
    $('input[name="check-lamp"]').each(index => {
      obj = $('input[name="check-lamp"]')[index]
      let tmp = {}
      tmp.target = obj
      this.onChangeLamp(tmp)
    })
  }

  onChangeLamp(e) {
    e.target.checked ?
      ScoreActionCreators.show(parseInt(e.target.value)) : ScoreActionCreators.hide(parseInt(e.target.value))
    if (e.target.value === 'hard' && e.target.checked) { this.recChangeLamp([Env.CLEAR, Env.EASY, Env.ASSIST, Env.FAILED, Env.NOPLAY]) }
    if (e.target.value === 'clear' && e.target.checked) { this.recChangeLamp([Env.ASSIST, Env.FAILED, Env.NOPLAY]) }
  }

  renderLampCheckbox() {
    let key = 0
    dom = this.props.lamp.map(lamp => {
      return (
        <label key={'lamp-checkbox-' + key}>
          <input id={'state-' + key} type='checkbox' value={key++} name='check-lamp' defaultChecked={true} onChange={this.onChangeLamp} />
          {lamp}
        </label>
      )
    })
    dom.push(<label key={'lamp-checkbox-' + key++}>
        <input type='checkbox' value='hard' defaultChecked={false} onChange={this.onChangeLamp} />
        未難
      </label>)
    dom.push(<label key={'lamp-checkbox-' + key}>
        <input type='checkbox' value='clear' defaultChecked={false} onChange={this.onChangeLamp} />
        未クリア
      </label>)
    return dom
  }

  render() {
    return (
      <div className='lamp-checkbox'>
        {this.renderLampCheckbox()}
      </div>
    )
  }
}

LampCheckbox.propTypes = {
  lamp: React.PropTypes.array.isRequired
}
