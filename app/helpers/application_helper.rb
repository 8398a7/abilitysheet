module ApplicationHelper
  def return_ability(cnt)
    params[:type] == 'clear' ? @sheets[cnt].n_ability : @sheets[cnt].h_ability
  end

  def return_ability_rival(cnt)
    params[:action] == 'clear' ? @sheets[cnt].n_ability : @sheets[cnt].h_ability
  end
end
