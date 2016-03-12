class @Checkbox extends React.Component
  constructor: (props) ->
    super

  stateCounter: =>
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
    if @props.sheetType is 0
      per = fc + exh + h + c + e
      remain = "(未クリア#{a + f + n})"
    else
      per = fc + exh + h
      remain = "(未難#{c + e + a + f + n})"
    $('td#per').text("(#{per}/#{all})")
    $('#remain').text(remain)

  componentDidMount: ->
    @stateCounter()

  render: ->
    <div className='checkbox'>
      <VersionCheckbox versions={@props.versions} stateCounter={@stateCounter} reverseSheet={@props.reverseSheet} />
      <LampCheckbox lamp={@props.lamp} />
    </div>

Checkbox.propTypes =
  versions: React.PropTypes.array.isRequired
  reverseSheet: React.PropTypes.bool.isRequired
  sheetType: React.PropTypes.number.isRequired
  lamp: React.PropTypes.array.isRequired
