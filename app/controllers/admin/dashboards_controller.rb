class Admin::DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :owner_user!

  def index
    begin
      @sidekiq = Process.getpgid(File.read("#{Rails.root}/tmp/pids/sidekiq.pid").chomp!.to_i)
    rescue
      @sidekiq = false
    end

    @email = User.where.not(email: '').count
    @message = Message.where(state: false).count
    @user = User.where(current_sign_in_at: Date.today..Date.today + 1).count
  end
end
