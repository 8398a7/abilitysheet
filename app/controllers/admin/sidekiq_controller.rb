class Admin::SidekiqController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user!

  def index
    @sidekiq = Process.getpgid(File.read("#{Rails.root}/tmp/pids/sidekiq.pid").chomp!.to_i)
  rescue
    @sidekiq = false
  end

  def start
    flash[:notice] = 'sidekiq start'
    system "/usr/bin/env bundle exec sidekiq --index 0 --pidfile #{ENV['SIDEKIQ_PID_PATH']} --environment #{Rails.env} --logfile #{ENV['SIDEKIQ_LOG_PATH']} --daemon"
    render :reload
  end
end
