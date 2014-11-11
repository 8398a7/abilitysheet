$('.modal-form').html('<%= escape_javascript( render partial: 'scores/form' ) %>')
$('#modal-form').modal()
