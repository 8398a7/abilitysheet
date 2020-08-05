# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
require 'capybara/rspec'
require 'sidekiq/testing'
require 'rspec/retry'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # rspec retry setting
  config.verbose_retry = true
  config.display_try_failure_messages = true
  config.around :each do |ex|
    ex.run_with_retry retry: ENV['RETRY_RSPEC']
  end

  config.before(:each, type: :system) do |example|
    if example.metadata[:js]
      if ENV['NO_HEADLESS']
        driven_by :selenium
      else
        driven_by :selenium, using: :headless_chrome, screen_size: [1920, 1080]
      end
    else
      driven_by :rack_test
    end
  end

  Sidekiq::Testing.inline!
end
