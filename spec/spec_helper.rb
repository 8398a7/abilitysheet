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
  Capybara.register_driver :selenium_chrome_headless do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  # rspec retry setting
  config.verbose_retry = true
  config.display_try_failure_messages = true
  config.around :each do |ex|
    ex.run_with_retry retry: ENV['RETRY_RSPEC']
  end

  config.before(:each, type: :system) do |example|
    if example.metadata[:js]
      if example.metadata[:iphone6]
        display_size = [375, 667]
        args = %w[--headless --disable-gpu --user-agent=iPhone]
      else
        display_size = [1920, 1080]
        args = %w[--headless --disable-gpu]
      end
      args.shift if ENV['NO_HEADLESS']
      caps = Selenium::WebDriver::Remote::Capabilities.chrome(chromeOptions: { args: args })
      driven_by :selenium, screen_size: display_size, options: { desired_capabilities: caps }
    else
      driven_by :rack_test
    end
  end

  Sidekiq::Testing.inline!
end
