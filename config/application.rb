require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module Abilitysheet
  class Application < Rails::Application
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
    config.autoload_paths += %W(#{config.root}/lib)

    # test_framework
    config.generators.test_framework = :rspec

    config.assets.paths << Rails.root.join('node_modules')
    config.assets.paths << Rails.root.join('bower_components')
    config.assets.components = %w(npm bower)

    SLACK_URI = URI.parse(ENV['NOTIFY_SLACK_URL']) if ENV['NOTIFY_SLACK_URL']

    config.react.camelize_props = true
  end
end
