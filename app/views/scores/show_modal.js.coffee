$('.uk-modal').html('<%= escape_javascript( render partial: 'scores/form', locals: { sheet: @sheet, score: @score } ) %>')
UIkit.modal('.uk-modal').show()
