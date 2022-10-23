Sentry.init do |config|
  config.breadcrumbs_logger = [:monotonic_active_support_logger, :http_logger, :sentry_logger]
  config.background_worker_threads = 0
  config.send_default_pii = true
  config.traces_sample_rate = 0.0 # set a float between 0.0 and 1.0 to enable performance monitoring
  config.dsn = ENV['SENTRY_DSN']
  config.capture_exception_frame_locals = true
  config.enabled_environments = %w[development production]
end
