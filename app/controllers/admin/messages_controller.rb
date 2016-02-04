class Admin::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user!
  before_action :load_message, except: [:index]

  def index
    @search = Message.search(params[:q])
    @messages = @search.result
  end

  def active
    @message.update!(state: true)
    redirect_to admin_messages_path
  end

  def inactive
    @message.update!(state: false)
    redirect_to admin_messages_path
  end

  private

  def load_message
    return unless params[:id]
    @message = Message.find_by(id: params[:id])
  end
end
