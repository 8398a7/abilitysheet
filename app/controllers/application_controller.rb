class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  private

  def player_check
    type = 'clear'
    type = 'hard' if params[:format] == 1
    @pos = %(/sheets/#{ params[:id] }/#{ type })
    render :reload unless current_player.iidxid == params[:id]
  end

  protected

  def configure_permitted_parameters
    # strong parametersを設定し、usernameを許可
    devise_parameter_sanitizer.for(:sign_up) << [:username, :iidxid, :djname]
  end
end
