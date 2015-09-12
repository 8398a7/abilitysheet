require File.expand_path('../boot', __FILE__)

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

    # copyright
    config.copyright = 'IIDX☆12参考表 by839 2014-2015'

    # Current git revision
    config.git_revision = `git log --abbrev-commit --pretty=oneline | head -1 | cut -d' ' -f1`

    # Current IIDX version
    config.iidx_version = 22

    # Current IIDX grade
    config.iidx_grade = 0

    # lib auto load
    config.autoload_paths += %W(#{config.root}/lib)

    # api auto load
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api')]
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]

    # test_framework
    config.generators.test_framework = 'rspec'

    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
  end
end
