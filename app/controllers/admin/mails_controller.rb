class Admin::MailsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user!

  def new
  end

  def create
    NoticeMail.form_deal(params[:email_address], params[:subject], params[:body]).deliver
    flash[:notice] = %(メールを送信しました)
    redirect_to new_admin_mail_path
  end
end
