set :stage, :staging
set :branch, 'develop'
set :rails_env, 'staging'
set :migration_role, 'db'

server ENV['STAGING_SERVER'], user: ENV['STAGING_USER'], roles: %w(web app db)

set :ssh_options, {
  keys: [File.expand_path('~/.ssh/id_rsa')],
  forward_agent: true,
  auth_methods: %w(publickey)
}
