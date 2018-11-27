# frozen_string_literal: true

module ApplicationHelper
  def return_ability_rival(cnt)
    params[:action] == 'clear' ? @sheets[cnt].n_ability : @sheets[cnt].h_ability
  end

  def adsense(slot = 2)
    react_component_wrapper 'Adsense', slot: slot
  end

  def react_component_wrapper(component, props = {})
    props[:context] = {
      sentry_dsn: ENV['SENTRY_JS_DSN']
    }
    react_component component, props
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
