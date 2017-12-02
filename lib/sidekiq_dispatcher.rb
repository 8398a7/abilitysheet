# frozen_string_literal: true

class SidekiqDispatcher
  PID = Rails.env.development? ? 'sidekiq.pid' : 'sidekiq-0.pid'
  def self.exists?
    return true if ENV['docker']
    Process.getpgid(File.read("#{Rails.root}/tmp/pids/#{PID}").chomp!.to_i)
    true
  rescue Errno::ENOENT
    false
  end

  def self.start!
    system "/usr/bin/env bundle exec sidekiq --index 0 --pidfile #{ENV['SIDEKIQ_PID_PATH']} --environment #{Rails.env} --logfile #{ENV['SIDEKIQ_LOG_PATH']} --daemon"
  end
end
