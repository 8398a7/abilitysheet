namespace :unicorn do
  desc 'Start unicorn'
  task(:start) do
    config = Rails.root.to_s + '/config/unicorn/development.rb'
    env = ENV['RAILS_ENV'] || 'production'
    sh "bundle exec unicorn_rails -D -c #{config} -E #{env}"
  end

  desc 'Stop unicorn'
  task(:stop) { unicorn_signal :QUIT }

  desc 'Restart unicorn with USR2'
  task(:restart) { unicorn_signal :USR2 }

  desc 'Increment number of worker processes'
  task(:increment) { unicorn_signal :TTIN }

  desc 'Decrement number of worker processes'
  task(:decrement) { unicorn_signal :TTOU }

  desc 'Unicorn pstree (depends on pstree command)'
  task(:pstree) do
    sh "pstree '#{unicorn_pid}'"
  end

  def unicorn_signal(signal)
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    File.read(Rails.root.to_s + '/tmp/pids/unicorn.pid').to_i
  rescue Errno::ENOENT
    raise "Unicorn doesn't seem to be running"
  end
end
