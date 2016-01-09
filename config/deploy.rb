# config valid only for current version of Capistrano
lock '3.4.0'

require 'dotenv'
Dotenv.overload

set :application, 'abilitysheet'
set :repo_url, 'https://github.com/8398a7/abilitysheet.git'

set :scm, :git
set :format, :pretty
set :log_level, :info
set :pty, true
set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/backup', 'vendor/bundle', 'vendor/assets/bower_components')
set :keep_releases, 5

set :default_env, path: '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
set :rbenv_type, :system

set :deploy_to, ENV['DEPLOY_TO']
set :sidekiq_role, :web

set :conditionally_migrate, true
set :deploy_via, :remote_cache
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  after :publishing, :restart
end

namespace :bower do
  desc 'Install bower'
  task :install do
    on roles(:web) do
      within release_path do
        execute :rake, 'bower:install bower:resolve CI=true'
      end
    end
  end
end
before 'deploy:compile_assets', 'bower:install'
