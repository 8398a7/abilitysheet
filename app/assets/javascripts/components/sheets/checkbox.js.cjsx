class @Checkbox extends React.Component
  constructor: (props) ->
    super

  onChangeVersion: (e) =>
    if e.target.checked
      $(".#{e.target.value}").show()
    else
      $(".#{e.target.value}").hide()
    if e.target.value is '0'
      $('input[name="version-check"]').prop 'checked', e.target.checked
      for obj in $('input[name="version-check"]')
        Sheet.music_change obj
    Sheet.state_counter @props.sheetType

  onChangeReverse: =>
    params = getQueryParams location.search
    url = location.origin + location.pathname
    if @props.reverseSheet is true
      delete params.reverse_sheet
      location.href = mergeQueryParams url, params
    else
      params.reverse_sheet = true
      location.href = mergeQueryParams url, params

  componentDidMount: ->
    Sheet.state_counter @props.sheetType

  renderVersionCheckbox: ->
    dom = []
    key = 1
    for version in @props.versions
      dom.push <label key={'version-checkbox-' + key++}>
          <input type='checkbox' value={version[1]} name='version-check' defaultChecked=true onChange={@onChangeVersion} />
          {version[0]}
        </label>
    dom.push <label key={'version-checkbox-' + key}>
        <input type='checkbox' value='0' name='reverse' checked={@props.reverseSheet} onChange={@onChangeReverse} />
        逆順表示
      </label>
    dom

  onChangeLamp: (e) =>
    if e.target.checked
      $(".state-#{e.target.value}").show()
    else
      $(".state-#{e.target.value}").hide()
    Sheet.state_counter @props.sheetType

  renderLampCheckbox: ->
    dom = []
    key = 0
    for lamp in @props.lamp
      dom.push <label key={'lamp-checkbox-' + key}>
          <input type='checkbox' value={key++} name='lamp-check' defaultChecked=true onChange={@onChangeLamp} />
          {lamp}
        </label>
    dom

  render: ->
    <div className='checkbox'>
      <div className='version-checkbox'>
        {@renderVersionCheckbox()}
      </div>
      <div className='lamp-checkbox'>
        {@renderLampCheckbox()}
      </div>
    </div>

Checkbox.propTypes =
  versions: React.PropTypes.array.isRequired
  reverseSheet: React.PropTypes.bool.isRequired
  sheetType: React.PropTypes.number.isRequired
  lamp: React.PropTypes.array.isRequired
