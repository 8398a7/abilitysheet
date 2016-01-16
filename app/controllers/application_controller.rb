class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :miniprofiler

  protected

  def detect_device_variant
    case request.user_agent
    when /iPhone|Android|Nokia|Mobile/
      request.variant = :mobile
    end
  end

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
    allow_parameters = %w(email username iidxid djname grade pref)
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
    redirect_to list_log_path
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

  def handle_unverified_request
    flash[:alert] = 'ページのトークンが切れています，再度お試し下さい'
    render :reload
  end
end
