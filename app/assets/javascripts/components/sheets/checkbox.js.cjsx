class @Checkbox extends React.Component
  constructor: (props) ->
    super

  state_counter: (sheet_type) ->
    tds = $('td[name="music"]')
    all = fc = exh = h = c = e = a = f = 0

    for td in tds
      continue if td.style.cssText is 'display: none;'
      all++
      fc++  if td.bgColor is '#ff8c00'
      exh++ if td.bgColor is '#ffd900'
      h++   if td.bgColor is '#ff6347'
      c++   if td.bgColor is '#afeeee'
      e++   if td.bgColor is '#98fb98'
      a++   if td.bgColor is '#9595ff'
      f++   if td.bgColor is '#c0c0c0'
    n = all - fc - exh - h - c - e - a - f
    $('td#fc').text(fc)
    $('td#exh').text(exh)
    $('td#h').text(h)
    $('td#c').text(c)
    $('td#e').text(e)
    $('td#a').text(a)
    $('td#f').text(f)
    $('td#n').text(n)
    per = 0
    remain = ''
    if sheet_type is 0
      per = fc + exh + h + c + e
      remain = "(未クリア#{a + f + n})"
    else
      per = fc + exh + h
      remain = "(未難#{c + e + a + f + n})"
    $('td#per').text("(#{per}/#{all})")
    $('#remain').text(remain)

  onChangeVersion: (e) =>
    if e.target.checked
      $(".#{e.target.value}").show()
    else
      $(".#{e.target.value}").hide()
    if e.target.value is '0'
      $('input[name="version-check"]').prop 'checked', e.target.checked
      for obj in $('input[name="version-check"]')
        tmp = {}
        tmp.target = obj
        @onChangeVersion tmp
    @state_counter @props.sheetType

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
    @state_counter @props.sheetType

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
    @state_counter @props.sheetType

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
