class LampCheckbox extends React.Component {
  constructor(props) {
    super()
    this.onChangeLamp = this.onChangeLamp.bind(this)
  }

  shouldComponentUpdate(nextProps, nextState) { return CheckComponentUpdate(this.props, nextProps, this.state, nextState) }

  recChangeLamp(array) {
    $('input[name="lamp-check"]').prop('checked', false);
    array.forEach(num => $('input[id="state-' + num + '"]').prop('checked', true))
    $('input[name="lamp-check"]').each(index => {
      obj = $('input[name="lamp-check"]')[index]
      tmp = {}
      tmp.target = obj
      this.onChangeLamp(tmp)
    })
  }

  onChangeLamp(e) {
    e.target.checked ?
      ScoreActionCreators.show(parseInt(e.target.value)) : ScoreActionCreators.hide(parseInt(e.target.value))
    if (e.target.value === '8' && e.target.checked) { this.recChangeLamp([3, 4, 5, 6, 7]) }
    if (e.target.value === '9' && e.target.checked) { this.recChangeLamp([5, 6, 7]) }
  }

  renderLampCheckbox() {
    key = 0
    dom = this.props.lamp.map(lamp => {
      return (<label key={'lamp-checkbox-' + key}>
        <input id={'state-' + key} type='checkbox' value={key++} name='lamp-check' defaultChecked={true} onChange={this.onChangeLamp} />
        {lamp}
      </label>)
    })
    dom.push(<label key={'lamp-checkbox-' + key}>
        <input type='checkbox' value={key++} name='remain-lamp-check' defaultChecked={false} onChange={this.onChangeLamp} />
        未難
      </label>)
    dom.push(<label key={'lamp-checkbox-' + key}>
        <input type='checkbox' value={key++} name='remain-lamp-check' defaultChecked={false} onChange={this.onChangeLamp} />
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
