rails_root = File.expand_path('../../', __FILE__)

worker_processes 2
working_directory rails_root


stderr_path %(#{ rails_root }/log/unicorn_error.log)
stdout_path %(#{ rails_root }/log/unicorn.log)
timeout 15 # 15秒Railsが反応しなければWorkerをkillしてタイムアウト
preload_app true # 後述

listen %(#{ rails_root }/tmp/unicorn.sock)

# pid file path Capistranoとか使う時は要設定か
pid %(#{ rails_root }/tmp/pids/unicorn.pid)

before_fork do |server, worker|
  old_pid = "#{ server.config[:pid] }.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      # 古いマスターがいたら死んでもらう
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
