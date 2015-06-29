module ApplicationHelper
  def return_ability(cnt)
    params[:type] == 'clear' ? @sheets[cnt].n_ability : @sheets[cnt].h_ability
  end
end
