# frozen_string_literal: true

module ApplicationHelper
  def return_ability_rival(cnt)
    params[:action] == 'clear' ? @sheets[cnt].n_ability : @sheets[cnt].h_ability
  end

  def rectangle_adsense
    react_component 'RectangleAdsense', client: 'ca-pub-5751776715932993', slot: '4549839260', slot2: '3454772069'
  end

  def responsive_adsense
    react_component 'ResponsiveAdsense', client: 'ca-pub-5751776715932993', slot: '6704745267'
  end

  def render_ads?
    return true unless current_user
    !(current_user.special? || current_user.owner?)
  end

  def recent_link(iidxid)
    user = User.find_by_iidxid(iidxid)
    return false unless user
    return false if user.logs.empty?
    logs_path(user.iidxid, user.logs.order(:created_date).last.created_date)
  end
end
