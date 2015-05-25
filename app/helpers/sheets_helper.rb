module SheetsHelper
  def return_ability(cnt)
    return params[:action] == 'clear' ? @sheets[cnt].ability : @sheets[cnt].h_ability
  end
end
