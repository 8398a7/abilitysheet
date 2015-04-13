REDIS_URL = { url: 'redis://localhost:6379', namespace: "sidekiq_#{ENV['USER']}" }

Sidekiq.configure_server do |config|
  config.redis = REDIS_URL
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::RetryJobs, max_retries: 0
    chain.add SidekiqMemoryKiller if ENV['SIDEKIQ_MEMORY_KILLER_MAX_RSS']
  end
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_URL
end
