# frozen_string_literal: true

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'puma:restart'
    invoke 'sidekiq:restart'
  end
end
