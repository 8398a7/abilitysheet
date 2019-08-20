# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Abilitysheet
  class Application < Rails::Application
    config.load_defaults 6.0
    config.time_zone = 'Tokyo'
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
    # lib auto load
    config.autoload_paths << "#{config.root}/lib"

    # test_framework
    config.generators.test_framework = :rspec

    SLACK_URI = URI.parse(ENV['NOTIFY_SLACK_URL']) if ENV['NOTIFY_SLACK_URL']
  end
end
