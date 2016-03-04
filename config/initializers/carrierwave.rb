CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY'],
    aws_secret_access_key: ENV['AWS_SECRET_KEY'],
    region: 'ap-northeast-1'
  }

  config.fog_directory = 'abilitysheet'
  config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/abilitysheet'
  config.fog_attributes = { 'Cache-Control' => 'public' }
end
