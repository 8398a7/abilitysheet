$(@).on 'page:fetch', ->
  $('.loading-container').show()
  NProgress.start()

$(@).on 'page:load page:restore page:change', ->
  $('.loading-container').hide()
  NProgress.done()

$(@).on 'load page:load', ->
  $('.searchable').select2()
