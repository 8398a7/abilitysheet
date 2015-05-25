class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :shift_domain

  def shift_domain
    host = 'iidxas.tk'
    if request.url.include?(host)
      path = Rails.root.join('tmp', 'shift_domain')
      num = File.read(path).to_i
      num += 1
      File.write(path, num)
      redirect_to request.url.gsub(host, 'iidx12.tk') and return
    end
  end

  protected

  def configure_permitted_parameters
    # strong parametersを設定し、usernameを許可
    devise_parameter_sanitizer.for(:sign_up) << [:username, :iidxid, :djname, :grade, :pref]
    devise_parameter_sanitizer.for(:account_update) << [:username, :djname, :grade, :pref]
  end

  def white_list
    return true if current_user.admin?
    flash[:alert] = '許可されていないページです'
    redirect_to root_path
  end
end
