class @Checkbox extends React.Component
  constructor: (props) ->
    super

  onChangeVersion: (e) =>
    if e.target.checked
      $(".#{e.target.value}").show()
    else
      $(".#{e.target.value}").hide()
    Sheet.state_counter()

  onChangeReverse: =>
    params = getQueryParams location.search
    url = location.origin + location.pathname
    if @props.reverseSheet is true
      delete params.reverse_sheet
      location.href = mergeQueryParams url, params
    else
      params.reverse_sheet = true
      location.href = mergeQueryParams url, params

  renderVersionCheckbox: ->
    dom = []
    key = 1
    for version in @props.versions
      dom.push <label key={'version-checkbox-' + key++}>
          <input type='checkbox' value={version[1]} name='check' defaultChecked=true onChange={@onChangeVersion} />
          {version[0]}
        </label>
    dom.push <label key={'version-checkbox-' + key}>
        <input type='checkbox' value='0' name='reverse' checked={@props.reverseSheet} onChange={@onChangeReverse} />
        逆順表示
      </label>
    dom

  render: ->
    <div className='version-checkbox'>
      {@renderVersionCheckbox()}
    </div>

Checkbox.propTypes =
  versions: React.PropTypes.array.isRequired
  reverseSheet: React.PropTypes.bool.isRequired
