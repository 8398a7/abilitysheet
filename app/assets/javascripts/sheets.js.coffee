$(document).on 'ready page:load', ->

  # 曲の表示非表示
  music_show = (obj) ->
    $(".#{obj.value}").show()
  music_hide = (obj) ->
    $(".#{obj.value}").hide()
  music_change = (obj) ->
    if obj.checked
      music_show(obj)
      state_counter()
    else
      music_hide(obj)
      state_counter()


  $('input[name="check"]').click ->
    if this.value is '0'
      $('input[name="check"]').prop('checked', this.checked)
      for obj in $('input[name="check"]')
        music_change(obj)
    music_change(this)

  # 統計情報
  state_counter = ->
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
    if gon.sheet_type is 0
      per = fc + exh + h + c + e
      remain = "未クリア#{a + f + n}"
    else
      per = fc + exh + h
      remain = "未難#{c + e + a + f + n}"
    $('td#per').text("(#{per}/#{all})")
    $('td#remain').text(remain)

  state_counter()
