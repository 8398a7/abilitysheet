REDIS_URL = { url: 'redis://localhost:6379' }

Sidekiq.configure_server do |config|
  config.redis = REDIS_URL
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::RetryJobs, max_retries: 0
  end
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_URL
end
