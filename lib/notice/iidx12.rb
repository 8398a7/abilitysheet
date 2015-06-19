class Notice::IIDX12
  def initialize
    @client = twitter_client_get
  end

  def tweet(msg)
    msg = (msg.length > 140) ? msg[0..139].to_s : msg
    @client.update(msg.chomp)
  rescue => e
    Rails.logger.error "<<twitter.rake::tweet.update ERROR : #{e.message}>>"
  end

  private

  def twitter_client_get
    keys = ENV['TWITTER'].split(',')
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = keys[0]
      config.consumer_secret     = keys[1]
      config.access_token        = keys[2]
      config.access_token_secret = keys[3]
    end
    client
  end
end
