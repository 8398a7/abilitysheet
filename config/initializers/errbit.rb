def get_revision
  return '' if Rails.env.development? || Rails.env.test?
  path = Rails.root.to_s.split('/')
  version = path.pop
  path.pop
  revisions = path.join('/') + '/revisions.log'
  revision = nil
  File.read(revisions).split("\n").each do |line|
    next unless line.include?(version)
    revision = line.match(/[a-z0-9]{7}/)[0]
  end
  '@' + revision
rescue
  return ''
end
if Rails.env.staging? || Rails.env.production?
  Airbrake.configure do |config|
    config.environment = Rails.env + get_revision
    config.ignore_environments = %w(development test)
    config.host        = ENV['ERRBIT_HOST']
    config.project_id  = true
    config.project_key = ENV['ERRBIT_API_KEY']
  end
end
