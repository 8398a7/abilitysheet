# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'abilitysheet-iidx'
set :repo_url, 'git@github.com:8398a7/abilitysheet-iidx.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/husq/deploy/abilitysheet-iidx'

# Default value for :scm is :git
set :scm, :git
set :bundle_path, -> { shared_path.join('vendor/bundle') }

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp vendor/bundle public/assets}

# Default value for default_env is {}
set :default_env, { path: '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH' }

# Default value for keep_releases is 5
set :keep_releases, 5

set :rbenv_type, :system # :system or :user
set :rbenv_ruby, '2.1.2'

set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end


  # 上記linked_filesで使用するファイルをアップロードするタスク
  # deployが行われる前に実行する必要がある。
  desc 'upload importabt files'
  task :upload do
    on roles(:app) do |host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!('config/database.yml',"#{shared_path}/config/database.yml")
      upload!('config/secrets.yml',"#{shared_path}/config/secrets.yml")
    end
  end

  before :starting, 'deploy:upload'
  after :publishing, :restart
  after :finishing, 'deploy:cleanup'
end
