<% if @user.errors.empty? %>
  location.reload(true)
<% else %>
  alert('<%= escape_javascript @user.errors.full_messages.join("\n") %>')
<% end %>
