<% if @sheet.errors.empty? %>
  location.reload(true)
<% else %>
  alert('<%= escape_javascript @sheet.errors.full_messages.join("\n") %>')
<% end %>
