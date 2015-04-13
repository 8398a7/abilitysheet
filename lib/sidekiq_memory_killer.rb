require 'open3'
require 'fileutils'

class SidekiqMemoryKiller
  MAX_RSS = (ENV['SIDEKIQ_MEMORY_KILLER_MAX_RSS'] || 0).to_s.to_i
  GRACE_TIME = (ENV['SIDEKIQ_MEMORY_KILLER_GRACE_TIME'] || 15 * 60).to_s.to_i
  SHUTDOWN_WAIT = (ENV['SIDEKIQ_MEMORY_KILLER_SHUTDOWN_WAIT'] || 30).to_s.to_i

  MUTEX = Mutex.new

  def call(worker, job, queue)
    yield
    current_rss = get_rss

    return unless MAX_RSS > 0 && current_rss > MAX_RSS

    Thread.new do
      return unless MUTEX.try_lock

      Sidekiq.logger.warn "current RSS #{current_rss} exceeds maximum RSS "\
        "#{MAX_RSS}"
      Sidekiq.logger.warn 'spawned thread that will shut down PID '\
        "#{Process.pid} in #{GRACE_TIME} seconds"
      sleep(GRACE_TIME)

      Sidekiq.logger.warn "sending SIGUSR1 to PID #{Process.pid}"
      Process.kill('SIGUSR1', Process.pid)

      Sidekiq.logger.warn "waiting #{SHUTDOWN_WAIT} seconds before sending "\
        "SIGTERM to PID #{Process.pid}"
      sleep(SHUTDOWN_WAIT)

      Sidekiq.logger.warn "sending SIGTERM to PID #{Process.pid}"
      Process.kill('SIGTERM', Process.pid)
    end
  end

  private

  def popen(cmd, path = nil)
    fail 'System commands must be given as an array of strings' unless cmd.is_a?(Array)

    path ||= Dir.pwd
    vars = { 'PWD' => path }
    options = { chdir: path }

    FileUtils.mkdir_p(path) unless File.directory?(path)

    @cmd_output = ''
    @cmd_status = 0
    Open3.popen3(vars, *cmd, options) do |stdin, stdout, stderr, wait_thr|
      stdin.close
      @cmd_output << stdout.read
      @cmd_output << stderr.read
      @cmd_status = wait_thr.value.exitstatus
    end

    [@cmd_output, @cmd_status]
  end

  def get_rss
    output, status = popen(%W(ps -o rss= -p #{Process.pid}))
    return 0 unless status.zero?

    output.to_i
  end
end
