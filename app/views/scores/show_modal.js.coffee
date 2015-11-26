$('.uk-modal').html('<%= escape_javascript( render partial: 'scores/form', locals: { sheet: @sheet, score: @score, pre_score: @pre_score } ) %>')
UIkit.modal('.uk-modal').show()
