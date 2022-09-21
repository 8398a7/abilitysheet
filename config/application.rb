require_relative 'boot'
require_relative '../lib/rails_log_silencer'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Abilitysheet
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.time_zone = 'Asia/Tokyo'
    config.active_record.default_timezone = :local
    config.active_storage.queues.purge = :active_storage
    config.active_storage.queues.analysis = :active_storage

    config.i18n.default_locale = :ja

    config.generators.template_engine = :slim
    config.generators.helper          = false
    config.generators.assets          = false

    # Current IIDX version
    config.iidx_version = ENV['IIDX_VERSION'].to_i

    # Current IIDX grade
    config.iidx_grade = ENV['IIDX_GRADE'].to_i


    config.add_autoload_paths_to_load_path

    # test_framework
    config.generators.test_framework = :rspec

    SLACK_URI = URI.parse(ENV['NOTIFY_SLACK_URL']) if ENV['NOTIFY_SLACK_URL']

    config.middleware.insert_before(Rails::Rack::Logger, RailsLogSilencer, %w[/api/v1/health_check])

    config.active_record.use_yaml_unsafe_load = true
  end
end
