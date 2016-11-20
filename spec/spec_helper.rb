# frozen_string_literal: true
require 'simplecov'
SimpleCov.start
require 'sidekiq/testing'
require 'capybara/poltergeist'
require 'tilt/coffee'
require 'rspec/retry'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # capybara setting
  Capybara.default_selector = :css
  Capybara.javascript_driver = :poltergeist
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, inspector: true)
  end

  # rspec retry setting
  config.verbose_retry = true
  config.display_try_failure_messages = true
  config.around :each do |ex|
    ex.run_with_retry retry: ENV['RETRY_RSPEC']
  end

  Sidekiq::Testing.inline!
end
