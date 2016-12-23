# frozen_string_literal: true
Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environments = %w(staging production)
end
