# frozen_string_literal: true

set :application, 'abilitysheet'
set :repo_url, 'https://github.com/8398a7/abilitysheet.git'

ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :deploy_to, '/var/www/app/abilitysheet'

set :log_level, ENV['DEPLOY_LOG_LEVEL'].to_sym
set :format, :pretty
if ENV['DEPLOY_OUTPUT'] == 'true'
  set :format, :airbrussh
  set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto
end
set :pty, true

set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/backup', 'vendor/bundle', 'public/uploads')

set :default_env, path: '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
set :rbenv_type, :system

set :keep_releases, 5

set :conditionally_migrate, true
set :deploy_via, :remote_cache

# slack notify
set :slack_username, 'Deploy Dispatcher'
set :slack_channel, '#abilitysheet'
set :slack_emoji, ''
set :slack_deploy_finished_color, 'good'
set :slack_deploy_failed_color, 'danger'
set :slack_url, ENV['NOTIFY_SLACK_URL']

# puma settings
set :puma_preload_app, true
set :puma_init_active_record, true
set :puma_threads, [8, 32]
set :puma_workers, 3
set :puma_worker_timeout, 15

set :sidekiq_role, :app
set :sidekiq_default_hooks, false
namespace :deploy do
  task :ts_routes do
    on roles(:app) do
      execute "cd #{release_path}; RAILS_ENV=#{fetch(:rails_env)} rails ts:routes"
    end
  end
  before 'deploy:compile_assets', 'deploy:ts_routes'
  after 'deploy:starting', 'sidekiq:quiet'
  after 'puma:restart', 'sidekiq:stop'
  before 'puma:check', 'puma:config'
end
