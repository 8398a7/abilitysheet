$('.uk-modal').html('<%= escape_javascript(render partial: "admin/sheets/form", locals: { sheet: @sheet }) %>')
UIkit.modal('.uk-modal').show()
