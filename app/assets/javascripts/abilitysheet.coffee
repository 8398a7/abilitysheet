$(@).on 'page:fetch', ->
  $('.loading-container').show()
  NProgress.start()

$(@).on 'page:load page:restore page:change', ->
  $('.loading-container').hide()
  NProgress.done()

$(@).on 'load page:load', ->
  $('.searchable').select2()

gradeSort = {
  '皆伝': 0
  '中伝': 1
  '十段': 2
  '九段': 3
  '八段': 4
  '七段': 5
  '六段': 6
  '五段': 7
  '四段': 8
  '三段': 9
  '二段': 10
  '初段': 11
  '初級': 12
  '二級': 13
  '三級': 14
  '四級': 15
  '五級': 16
  '六級': 17
  '七級': 18
}
$.extend $.fn.DataTable.ext.oSort,
  'grade': (a) ->
    a
  'grade-asc': (x, y) ->
    x = gradeSort[x]
    y = gradeSort[y]
    if x < y then -1 else if x > y then 1 else 0
  'grade-desc': (x, y) ->
    x = gradeSort[x]
    y = gradeSort[y]
    if x < y then 1 else if x > y then -1 else 0

@adsenseLoad = ->
  (adsbygoogle = window.adsbygoogle || []).push({})
