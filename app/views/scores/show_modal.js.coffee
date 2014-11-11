$('.modal-form').html('<%= escape_javascript( render partial: 'scores/form', locals: { score: @score, title: @title } ) %>')
$('#modal-form').modal()
