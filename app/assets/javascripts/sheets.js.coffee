$(document).on 'ready page:load', ->
  music_show = (obj) ->
    $(".#{obj.value}").show()
  music_hide = (obj) ->
    $(".#{obj.value}").hide()
  music_change = (obj) ->
    if obj.checked
      music_show(obj)
    else
      music_hide(obj)


  $('input[name="check"]').click ->
    if this.value is '0'
      $('input[name="check"]').prop('checked', this.checked)
      for obj in $('input[name="check"]')
        music_change(obj)
    music_change(this)
