class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    message = Message.new(message_params)
    message.user_id = current_user.id if user_signed_in?
    message.ip = request.remote_ip
    result = message.save
    if result
      NoticeMail.new_message(message.id).deliver_now
      flash[:notice] = '承りました。対応はしばしお待ちください。'
    else
      flash[:alert] = '何らかの不具合で送信できていません。Twitterなどにご連絡下さい。'
    end
    redirect_to root_path
  end

  private

  def message_params
    params.require(:message).permit(
      :email, :body
    )
  end
end
