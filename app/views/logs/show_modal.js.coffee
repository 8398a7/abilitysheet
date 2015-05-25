$('.uk-modal').html('<%= escape_javascript( render partial: 'logs/form' ) %>')
UIkit.modal('.uk-modal').show()
