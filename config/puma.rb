# RAILS_ENV=production bundle exec puma -C ./config/puma.rb

rails_env = ENV['RAILS_ENV'] || 'production'
if rails_env == 'production' || rails_env == 'staging'
  application_path = File.expand_path('../..', __FILE__)
  directory application_path

  environment rails_env
  daemonize true

  pidfile "#{application_path}/tmp/pids/puma.pid"
  state_path "#{application_path}/tmp/pids/puma.state"
  stdout_redirect "#{application_path}/log/puma.stdout.log", "#{application_path}/log/puma.stderr.log"

  workers 3
  threads 8, 32
  preload_app!
  bind "unix://#{application_path}/tmp/sockets/puma.socket"

  before_fork do
    ActiveRecord::Base.connection_pool.disconnect!
  end

  on_worker_boot do
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.establish_connection
    end
  end
end
