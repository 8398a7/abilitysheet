Airbrake.configure do |config|
  config.host        = ENV['ERRBIT_HOST']
  config.project_id  = true
  config.project_key = ENV['ERRBIT_API_KEY']
end
