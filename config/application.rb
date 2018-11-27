# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Abilitysheet
  class Application < Rails::Application
    config.load_defaults 5.2
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.i18n.default_locale = :ja

    config.generators.template_engine = :slim
    config.generators.helper          = false
    config.generators.assets          = false

    # Current IIDX version
    config.iidx_version = ENV['IIDX_VERSION'].to_i

    # Current IIDX grade
    config.iidx_grade = ENV['IIDX_GRADE'].to_i

    # lib auto load
    config.autoload_paths += %W[#{config.root}/lib]
    config.eager_load_paths += %W[#{config.root}/lib]

    # test_framework
    config.generators.test_framework = :rspec

    SLACK_URI = URI.parse(ENV['NOTIFY_SLACK_URL']) if ENV['NOTIFY_SLACK_URL']
  end
end
