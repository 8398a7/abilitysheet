# frozen_string_literal: true

module ApplicationHelper
  def return_ability_rival(cnt)
    params[:action] == 'clear' ? @sheets[cnt].n_ability : @sheets[cnt].h_ability
  end

  def react_component_wrapper(component, props = {})
    props[:context] = {
      sentry_dsn: ENV['SENTRY_JS_DSN']
    }
    react_component component, props
  end

  def render_ads?
    return true unless current_user

    !(current_user.admin? || current_user.skip_ad?)
  end

  def recent_link(iidxid)
    user = User.find_by_iidxid(iidxid)
    return false unless user
    return false if user.logs.empty?

    logs_path(user.iidxid, user.logs.order(:created_date).last.created_date)
  end

  def icon(name, text = nil, html_options = {}, style: 'fas')
    if text.is_a?(Hash)
      html_options = text
      text = nil
    end

    content_class = "#{style} fa-#{name}"
    content_class << " #{html_options[:class]}" if html_options.key?(:class)
    html_options[:class] = content_class

    html = content_tag(:i, nil, html_options)
    html << ' ' << text.to_s unless text.blank?
    html
  end
end
