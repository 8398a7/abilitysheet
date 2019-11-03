# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authenticate_user!

  def google_oauth2
    callback_from :google_oauth2
  end

  private

  def auth
    request.env['omniauth.auth']
  end

  def callback_from(provider)
    @provider = provider.to_s
    @user = User.find_for_oauth(auth, current_user)

    if @user.nil?
      user_nil_case
    elsif @user.persisted?
      user_persisted_case
    end
  end

  def user_nil_case
    # NOTE: 連携アカウントのメアドで登録はしているが未連携の場合
    if User.exists?(email: auth.info.email)
      flash[:danger] = "#{auth.info.email}は登録済みですが、未連携です"
      redirect_to oauth_helps_url
      return
    end
    # NOTE: 新規ユーザの場合
    # .find_for_oauthで@userが見つからないので @user.nil? => true
    flash[:danger] = '最初に登録が必要です。'
    redirect_to new_user_registration_url
  end

  def user_persisted_case
    # NOTE: 既に連携済のユーザがログインに利用した場合
    # 未ログインのためcurrent_userはnilだが、auth情報から@userが引けるため
    if current_user.nil?
      sign_in @user
      flash[:notice] = "#{@provider.split('_')[0].capitalize}を利用したログインに成功しました"
      redirect_to after_sign_in_path_for(:user)
      return
    end

    # NOTE: 登録済ユーザが連携を行おうとした場合
    # current_userがnilではなく、@userが引けるケース
    flash[:notice] = '連携に成功しました'
    redirect_to edit_user_registration_path
  end
end
