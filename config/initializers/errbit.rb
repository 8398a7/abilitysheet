Airbrake.configure do |config|
  config.api_key = 'c5d8da5efd55c8bfc1daf84054496ea0'
  config.host    = 'iidxas.herokuapp.com'
  config.port    = 443
  config.secure  = config.port == 443
end
