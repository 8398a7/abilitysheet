require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
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

  # rspec retry setting
  config.verbose_retry = true
  config.display_try_failure_messages = true
  config.around :each do |ex|
    ex.run_with_retry retry: 3
  end

  Sidekiq::Testing.inline!
end
