# frozen_string_literal: true
class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      flash[:notice] = '再発行メールを送信しました'
      flash[:alert] = '届いていない場合は迷惑メールフォルダをご確認下さい'
    elsif !User.exists?(email: resource.email)
      flash[:alert] = '登録されていないメールアドレスです'
    else
      flash[:alert] = '何らかの不具合によりメールが送れませんでした．管理人に連絡下さい'
    end
    redirect_to root_path
  end
end
