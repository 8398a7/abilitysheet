require 'rack-mini-profiler'
Rack::MiniProfiler.config.skip_paths ||= []
Rack::MiniProfiler.config.skip_paths << '/admins/model'
Rack::MiniProfiler.config.skip_paths << '/admins/sidekiq'
