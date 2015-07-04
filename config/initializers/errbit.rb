Airbrake.configure do |config|
  config.api_key = ENV['ERRBIT_API_KEY']
  config.host    = 'iidx12.herokuapp.com'
  config.port    = 443
  config.secure  = config.port == 443
end
