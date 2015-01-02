$('.modal-form').html('<%= escape_javascript( render partial: 'scores/form', locals: { textage: @textage, score: @score, title: @title } ) %>')
$('#modal-form').modal()
