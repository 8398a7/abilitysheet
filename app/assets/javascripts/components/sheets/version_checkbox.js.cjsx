class @VersionCheckbox extends React.Component
  constructor: (props) ->
    super
    @state =
      reverse: EnvironmentStore.findBy 'reverseSheet'

  onChangeReverseState: =>
    @setState reverse: EnvironmentStore.findBy 'reverseSheet'

  componentWillMount: ->
    EnvironmentStore.addChangeListener @onChangeReverseState

  componentWillUnmountMount: ->
    EnvironmentStore.removeChangeListener @onChangeReverseState

  onChangeVersion: (e) =>
    if e.target.checked
      SheetActionCreators.show parseInt e.target.value
    else
      SheetActionCreators.hide parseInt e.target.value
    if e.target.value is '0'
      $('input[name="version-check"]').prop 'checked', e.target.checked
      for obj in $('input[name="version-check"]')
        tmp = {}
        tmp.target = obj
        @onChangeVersion tmp

  onChangeReverse: =>
    params = getQueryParams location.search
    url = location.origin + location.pathname
    if @state.reverse is true
      delete params.reverse_sheet
      history.pushState '', '', mergeQueryParams url, params
    else
      params.reverse_sheet = true
      history.pushState '', '', mergeQueryParams url, params
    EnvironmentActionCreators.changeReverse !@state.reverse

  renderVersionCheckbox: ->
    dom = []
    key = 1
    for version in @props.versions
      # ALLの時はnameを変えないと再帰し続ける
      if version[1] is 0
        dom.push <label key={'version-checkbox-' + key++}>
            <input type='checkbox' value={version[1]} name='all-version-check' defaultChecked=true onChange={@onChangeVersion} />
            {version[0]}
          </label>
        continue
      dom.push <label key={'version-checkbox-' + key++}>
          <input type='checkbox' value={version[1]} name='version-check' defaultChecked=true onChange={@onChangeVersion} />
          {version[0]}
        </label>
    dom.push <label key={'version-checkbox-' + key}>
        <input type='checkbox' value='0' name='reverse' checked={@state.reverse} onChange={@onChangeReverse} />
        逆順表示
      </label>
    dom

  render: ->
    <div className='version-checkbox'>
      {@renderVersionCheckbox()}
    </div>

VersionCheckbox.propTypes =
  versions: React.PropTypes.array.isRequired
