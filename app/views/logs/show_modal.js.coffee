$('.uk-modal').html('<%= escape_javascript( render partial: 'logs/form', locals: { log: @log } ) %>')
UIkit.modal('.uk-modal').show()
