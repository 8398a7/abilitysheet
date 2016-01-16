module ApplicationHelper
  def return_ability(cnt)
    params[:type] == 'clear' ? @sheets[cnt].n_ability : @sheets[cnt].h_ability
  end

  def return_ability_rival(cnt)
    params[:action] == 'clear' ? @sheets[cnt].n_ability : @sheets[cnt].h_ability
  end

  def mobile?
    return false if params[:device] == 'pc'
    device_mobile?
  end

  def device_mobile?
    return true if request.user_agent =~ /iPhone|Android|Nokia|Mobile/
    false
  end
end
