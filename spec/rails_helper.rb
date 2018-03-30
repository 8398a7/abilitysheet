# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.order = :random

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include SessionHelpers
  config.include ApiHelper, type: :request
  config.include Warden::Test::Helpers
  config.include FactoryBot::Syntax::Methods
  config.include SheetsHelper
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

RedisHelper.load_sheets_data
