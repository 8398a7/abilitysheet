app_path = '/home/rails/deploy/abilitysheet'
app_shared_path = "#{app_path}/shared"

worker_processes 3

working_directory "#{app_path}/current"

listen "#{app_shared_path}/tmp/sockets/unicorn.sock"

stdout_path "#{app_shared_path}/log/unicorn.stdout.log"
stderr_path "#{app_shared_path}/log/unicorn.stderr.log"

pid "#{app_shared_path}/tmp/pids/unicorn.pid"

preload_app true

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
  old_pid = "#{server.config[:pid]}.oldbin"
  unless old_pid == server.pid
    begin
      Process.kill :QUIT, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
