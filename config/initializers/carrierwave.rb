CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY'],
    aws_secret_access_key: ENV['AWS_SECRET_KEY'],
    region: 'ap-northeast-1'
  }

  case Rails.env
  when 'production'
    config.fog_directory = 'abilitysheet'
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/abilitysheet'
  when 'development'
    config.fog_directory = 'dev.abilitysheet'
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/dev.abilitysheet'
  when 'test'
    config.fog_directory = 'test.abilitysheet'
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/test.abilitysheet'
  end
  config.fog_attributes = { 'Cache-Control' => 'public' }
end
