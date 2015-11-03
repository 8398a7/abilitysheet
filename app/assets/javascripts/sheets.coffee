$(window).on 'page:fetch', ->
  $('.loading-container').show()
  NProgress.start()

$(window).on 'page:load page:restore page:change', ->
  $('.loading-container').hide()
  NProgress.done()

$(@).on 'load page:load', ->
  $('.searchable').select2()
