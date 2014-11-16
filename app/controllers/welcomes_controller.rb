class WelcomesController < ApplicationController
  def index
    @update_logs = Notice.where(state: 0, active: true).limit(5).order(created_at: :desc)
    @notices = Notice.where(state: 1, active: true).limit(5).order(created_at: :desc)
  end

  def list
    @users = User.all
    @color = Score.list_color
  end

  def message
    @message = Message.new
  end

  def create_message
    message = Message.new
    message.user_id = current_user.id if user_signed_in?
    message.body = params[:message][:body]
    message.ip = request.remote_ip
    result = message.save
    flash[:notice] = '承りました。対応はしばしお待ちください。' if result
    flash[:alert] = '何らかの不具合で送信できていません。Twitterなどにご連絡下さい。' unless result
    redirect_to root_path
  end

  def test
    reg = Scrape::Register.new
    @hoge = reg.get
  end
end
