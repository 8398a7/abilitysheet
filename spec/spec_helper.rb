require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'sidekiq/testing'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Capybara::DSL

  Capybara.default_selector = :css
  Capybara.javascript_driver = :poltergeist
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, inspector: true)
  end

  Sidekiq::Testing.inline!
end
