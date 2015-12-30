unless Rails.env.test?
  Airbrake.configure do |config|
    config.project_id  = ENV['ERRBIT_API_KEY']
    config.project_key = ENV['ERRBIT_API_KEY']
    config.host        = ENV['ERRBIT_HOST']
  end
end
