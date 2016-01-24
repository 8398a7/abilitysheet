class SidekiqDispatcher
  PID = Rails.env.development? ? 'sidekiq.pid' : 'sidekiq-0.pid'
  def self.exists?
    Process.getpgid(File.read("#{Rails.root}/tmp/pids/#{PID}").chomp!.to_i)
    true
  rescue
    false
  end

  def self.start!
    system "/usr/bin/env bundle exec sidekiq --index 0 --pidfile #{ENV['SIDEKIQ_PID_PATH']} --environment #{Rails.env} --logfile #{ENV['SIDEKIQ_LOG_PATH']} --daemon"
  end
end
