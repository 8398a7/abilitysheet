require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'factory_girl_rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'database_cleaner'
require 'warden'
require 'devise'
require 'sidekiq/testing'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.include Warden::Test::Helpers
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL

  config.order = 'random'

  config.before(:all) do
    Capybara.default_selector = :css
    Capybara.javascript_driver = :poltergeist
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: true)
end
