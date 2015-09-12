# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'abilitysheet'
set :repo_url, 'https://github.com/8398a7/abilitysheet.git'

set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, true
set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle')
set :keep_releases, 5

set :default_env, { path: '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH' }
set :rbenv_type, :system

set :deploy_to, '/home/rails/deploy/abilitysheet'
set :sidekiq_role, :web

set :conditionally_migrate, true
set :deploy_via, :remote_cache

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  after :publishing, :restart
  after 'deploy:finished', 'airbrake:deploy'
end

namespace :bower do
  desc 'Install bower'
  task :install do
    on roles(:web) do
      within release_path do
        execute :rake, 'bower:install CI=true'
        execute :rake, 'bower:resolve CI=true'
      end
    end
  end
end
before 'deploy:compile_assets', 'bower:install'
