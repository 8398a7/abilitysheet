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

  def rectangle_adsense
    react_component 'RectangleAdsense', client: 'ca-pub-5751776715932993', slot: '4549839260', slot2: '3454772069', mobile: mobile?
  end

  def responsive_adsense
    react_component 'ResponsiveAdsense', client: 'ca-pub-5751776715932993', slot: '6704745267'
  end
end
