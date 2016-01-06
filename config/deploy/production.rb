set :stage, :production
set :branch, 'master'
set :rails_env, 'production'
set :migration_role, 'db'

if ENV['PRODUCTION_PORT']
  server ENV['PRODUCTION_SERVER'], user: ENV['PRODUCTION_USER'], port: ENV['PRODUCTION_PORT'], roles: %w(web app db)
else
  server ENV['PRODUCTION_SERVER'], user: ENV['PRODUCTION_USER'], roles: %w(web app db)
end

set :ssh_options, {
  keys: [File.expand_path(ENV['RSA_KEY'])],
  forward_agent: true,
  auth_methods: %w(publickey)
}
