# This file is used by Rack-based servers to start the application.
require 'unicorn/worker_killer'

# Max requests per worker
use Unicorn::WorkerKiller::MaxRequests, 3072, 4096

# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, (192 * (1024**2)), (256 * (1024**2))

require ::File.expand_path('../config/environment',  __FILE__)
if ENV['RAILS_RELATIVE_URL_ROOT']
  map ENV['RAILS_RELATIVE_URL_ROOT'] do
    run Rails.application
  end
else
  run Rails.application
end
