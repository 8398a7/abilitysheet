# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
require 'capybara'
require 'sidekiq/testing'
require 'tilt/coffee'
require 'rspec/retry'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  Capybara.raise_server_errors = false

  # rspec retry setting
  config.verbose_retry = true
  config.display_try_failure_messages = true
  config.around :each do |ex|
    ex.run_with_retry retry: ENV['RETRY_RSPEC']
  end

  Sidekiq::Testing.inline!
end
