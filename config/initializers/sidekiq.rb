redis_params = { url: ENV['REDIS_URL'] }

Sidekiq.configure_server do |config|
  config.redis = redis_params
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::RetryJobs, max_retries: 0
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_params
end
