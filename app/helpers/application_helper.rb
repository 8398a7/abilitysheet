module ApplicationHelper
  def return_ability(cnt)
    return params[:action] == 'clear' ? @sheets[cnt].n_ability : @sheets[cnt].h_ability
  end
end
