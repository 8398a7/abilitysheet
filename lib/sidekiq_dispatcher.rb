class SidekiqDispatcher
  PID = Rails.env.development? ? 'sidekiq.pid' : 'sidekiq-0.pid'
  def self.exists?
    Process.getpgid(File.read("#{Rails.root}/tmp/pids/#{PID}").chomp!.to_i)
    true
  rescue
    false
  end
end
