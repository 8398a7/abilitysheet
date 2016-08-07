# frozen_string_literal: true
class TwitterDispatcher
  def initialize
    tokens = ENV['TWITTER_TOKENS'].split(',')
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = tokens[0]
      config.consumer_secret     = tokens[1]
      config.access_token        = tokens[2]
      config.access_token_secret = tokens[3]
    end
  end

  def tweet(text)
    @client.update(text)
  end
end
