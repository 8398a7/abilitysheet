$('.uk-modal').html('<%= escape_javascript(render partial: "admin/users/form", locals: { user: @user }) %>')
UIkit.modal('.uk-modal').show()
