class @LampCheckbox extends React.Component
  constructor: (props) ->
    super

  onChangeLamp: (e) =>
    if e.target.checked
      ScoreActionCreators.show parseInt e.target.value
    else
      ScoreActionCreators.hide parseInt e.target.value
    if e.target.value is '8' and e.target.checked
      $('input[name="lamp-check"]').prop 'checked', false
      for num in [3..7]
        $("input[id=\"state-#{num}\"]").prop 'checked', true
      for obj in $('input[name="lamp-check"]')
        tmp = {}
        tmp.target = obj
        @onChangeLamp tmp
    if e.target.value is '9' and e.target.checked
      $('input[name="lamp-check"]').prop 'checked', false
      for num in [5..7]
        $("input[id=\"state-#{num}\"]").prop 'checked', true
      for obj in $('input[name="lamp-check"]')
        tmp = {}
        tmp.target = obj
        @onChangeLamp tmp

  renderLampCheckbox: ->
    dom = []
    key = 0
    for lamp in @props.lamp
      dom.push <label key={'lamp-checkbox-' + key}>
          <input id={'state-' + key} type='checkbox' value={key++} name='lamp-check' defaultChecked=true onChange={@onChangeLamp} />
          {lamp}
        </label>
    dom.push <label key={'lamp-checkbox-' + key}>
        <input type='checkbox' value={key++} name='remain-lamp-check' defaultChecked=false onChange={@onChangeLamp} />
        未難
      </label>
    dom.push <label key={'lamp-checkbox-' + key}>
        <input type='checkbox' value={key++} name='remain-lamp-check' defaultChecked=false onChange={@onChangeLamp} />
        未クリア
      </label>
    dom

  render: ->
    <div className='lamp-checkbox'>
      {@renderLampCheckbox()}
    </div>

LampCheckbox.propTypes =
  lamp: React.PropTypes.array.isRequired
