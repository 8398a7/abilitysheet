# frozen_string_literal: true

namespace :assets_rails do
  desc 'Install assets and resolve assets'
  task :install do
    on roles(:web) do
      within release_path do
        execute :rake, 'assets_rails:install assets_rails:resolve RAILS_ENV=production'
      end
    end
  end
end
before 'deploy:compile_assets', 'assets_rails:install'
