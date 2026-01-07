# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
require 'openssl'
require 'capybara/rspec'
require 'sidekiq/testing'
require 'rspec/retry'
require 'webdrivers'

# Retry with VERIFY_NONE only when TLS fails due to missing CRL data.
module Webdrivers
  class Network
    class << self
      alias get_response_without_crl_fallback get_response

      def get_response(url, limit = 10)
        get_response_without_crl_fallback(url, limit)
      rescue OpenSSL::SSL::SSLError => e
        raise unless e.message.include?('unable to get certificate CRL')

        Webdrivers.logger.warn('webdrivers SSL error: retrying with VERIFY_NONE')
        get_response_with_insecure_ssl(url, limit)
      end

      private

      def get_response_with_insecure_ssl(url, limit = 10)
        raise ConnectionError, 'Too many HTTP redirects' if limit.zero?

        uri = URI(url)
        response = http.start(uri.host, uri.port, use_ssl: uri.scheme == 'https',
                                                  verify_mode: OpenSSL::SSL::VERIFY_NONE) do |client|
          client.get(uri.request_uri)
        end

        Webdrivers.logger.debug "Get response: #{response.inspect}"

        if response.is_a?(Net::HTTPRedirection)
          location = response['location']
          Webdrivers.logger.debug "Redirected to #{location}"
          get_response_with_insecure_ssl(location, limit - 1)
        else
          response
        end
      rescue SocketError
        raise ConnectionError, "Can not reach #{url}"
      end
    end
  end
end

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
