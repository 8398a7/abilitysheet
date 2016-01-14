$(@).on 'page:fetch', ->
  $('.loading-container').show()
  NProgress.start()

$(@).on 'page:load page:restore page:change', ->
  $('.loading-container').hide()
  NProgress.done()

$(@).on 'load page:load', ->
  $('.searchable').select2()

ready = ->
  loadTwitterSDK()
  bindTwitterEventHandlers() unless twttr_events_bound

$(document).ready ready
$(document).on 'page:load', ready

twttr_events_bound = false

bindTwitterEventHandlers = ->
  $(document).on 'page:load', renderTweetButtons
  twttr_events_bound = true

renderTweetButtons = ->
  $('.twitter-share-button').each ->
    button = $(this)
    button.attr('data-url', document.location.href) unless button.data('url')?
    button.attr('data-text', document.title) unless button.data('text')?
  twttr.widgets.load()

loadTwitterSDK = ->
  $.getScript("//platform.twitter.com/widgets.js")
