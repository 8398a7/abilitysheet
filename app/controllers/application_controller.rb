class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :shift_domain
  before_action :miniprofiler
  before_action :load_nav_routes

  def shift_domain
    host = 'iidxas.tk'
    return unless request.url.include?(host)
    path = Rails.root.join('tmp', 'shift_domain')
    num = File.read(path).to_i
    num += 1
    File.write(path, num)
    redirect_to request.url.gsub(host, 'iidx12.tk')
  end

  def load_nav_routes
    @paths = {}
    @paths[:root] = root_path
    @paths[:users] = users_path
    @paths[:recommend] = list_recommends_path
    @paths[:integration_recommend] = integration_recommends_path
    @paths[:new_message] = new_message_path
    return unless user_signed_in?
    @paths[:clear_sheet] = sheet_path(current_user.iidxid, type: 'clear')
    @paths[:hard_sheet] = sheet_path(current_user.iidxid, type: 'hard')
    @paths[:power_sheet] = sheet_path(current_user.iidxid, type: 'power')
    @paths[:logs_list] = list_logs_path(current_user.iidxid)
    @paths[:rival_list] = list_rival_path
    @paths[:reverse_rival_list] = reverse_list_rival_path
  end

  protected

  def scores_exists?
    return if current_user.scores.present?
    flash[:alert] = '処理を受け付けませんでした．'
    flash[:notice] = 'この状態が続くようであればお問い合わせください'
    render :reload
  end

  def return_404
    render file: Rails.root.join('public', '404.html'), status: 404, layout: true, content_type: 'text/html'
  end

  def check_xhr
    return if request.xhr?
    return_404
  end

  def configure_permitted_parameters
    allow_parameters = %w(username iidxid djname grade pref)
    devise_parameter_sanitizer.for(:sign_up) << allow_parameters
    devise_parameter_sanitizer.for(:account_update) << allow_parameters
  end

  def admin_user!
    return true if current_user.admin?
    flash[:alert] = '許可されていないページです'
    redirect_to root_path
  end

  def special_user!
    return if current_user.special?
    flash[:alert] = '不正な操作です．'
    redirect_to list_logs_path
  end

  def owner_user!
    return if current_user.owner?
    flash[:alert] = '許可されていないページです'
    redirect_to root_path
  end

  def member_user!
    return if current_user.member?
    flash[:alert] = '許可されていないページです'
    redirect_to root_path
  end

  def miniprofiler
    Rack::MiniProfiler.authorize_request if user_signed_in? && current_user.admin?
  end
end
