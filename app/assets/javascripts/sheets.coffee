$(window).on 'page:fetch', ->
  $('.loading-container').show()

$(window).on 'page:load page:restore page:change', ->
  $('.loading-container').hide()

