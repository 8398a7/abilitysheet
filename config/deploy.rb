# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'abilitysheet'
set :repo_url, 'https://github.com/8398a7/abilitysheet.git'

set :scm, :git
set :format, :pretty
set :log_level, :warn
set :pty, true
set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/backup', 'vendor/bundle')
set :keep_releases, 5

set :default_env, path: '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
set :rbenv_type, :system

set :deploy_to, '/var/www/app/abilitysheet'
set :sidekiq_role, :web

set :conditionally_migrate, true
set :deploy_via, :remote_cache
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

# slack notify
set :slack_username, 'Deploy Dispatcher'
set :slack_channel, '#abilitysheet'
set :slack_emoji, ''
set :slack_deploy_finished_color, 'good'
set :slack_deploy_failed_color, 'danger'
set :slack_url, ENV['NOTIFY_SLACK_URL']

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'puma:restart'
  end

  after :publishing, :restart
end

namespace :npm do
  desc 'Install npm'
  task :install do
    on roles(:web) do
      within release_path do
        execute :rake, 'npm:install npm:resolve'
      end
    end
  end
end
before 'deploy:compile_assets', 'npm:install'
