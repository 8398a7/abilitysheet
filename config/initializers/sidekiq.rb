redis_params = { url: ENV['REDIS_URL'] }

Sidekiq.configure_server do |config|
  config.redis = redis_params
end

Sidekiq.configure_client do |config|
  config.redis = redis_params
end

Sidekiq.default_job_options = { retry: 0 }

schedule_file = 'config/schedule.yml'
if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
