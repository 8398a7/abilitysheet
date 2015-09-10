class Admin::DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :owner_user!

  def index
    begin
      @sidekiq = Process.getpgid(File.read("#{Rails.root}/tmp/pids/sidekiq.pid").to_i)
    rescue
      @sidekiq = false
    end

    @email = User.where.not(email: '').count
    @message = Message.where(state: false).count
    @user = User.where(current_sign_in_at: Date.today..Date.today + 1).count
    @app_memory = (`ps -o rss= -p #{Process.pid}`.to_i / 1024.0).round(2)
    @sidekiq_memory = (`ps -o rss= -p #{@sidekiq + 1}`.to_i / 1024.0).round(2) if @sidekiq
    @used_memory = (`ps aux | tail -n +2 | awk -F' ' '{sum += $6} END {print sum}'`.to_i / 1024.0).round(2)
    @margin_memory = ENV['MEMORY'].to_i - @used_memory
  end
end
