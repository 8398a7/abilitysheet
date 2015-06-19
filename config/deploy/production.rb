set :stage, :production
set :branch, 'master'
set :rails_env, 'production'
set :migration_role, 'db'

server 'iidx12', user: 'rails', roles: %w(web app db)

set :ssh_options, {
  keys: [File.expand_path('~/.ssh/id_rsa')],
  forward_agent: true,
  auth_methods: %w(publickey)
}
