$('.uk-modal').html('<%= escape_javascript( render partial: 'scores/form', locals: { textage: @textage, score: @score, title: @title } ) %>')
UIkit.modal('.uk-modal').show()
