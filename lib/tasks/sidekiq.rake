namespace :sidekiq do
  desc 'Start sidekiq'
  task start: :environment do
    system "bundle exec sidekiq -C #{Rails.root.join('config', 'sidekiq.yml')}"
  end

  task :sidekiqctl, [:name, :deadline_timeout] => :environment do |t, args|
    system "bundle exec sidekiqctl #{args[:name]} #{Rails.root.join('tmp', 'pids', 'sidekiq.pid')} #{args[:deadline_timeout]}"
  end

  desc 'Quiet sends USR1 to sidekiq'
  task quiet: :environment do
    Rake::Task['sidekiq:sidekiqctl'].invoke('quiet')
  end

  desc 'Stop sends TERM to sidekiq'
  task stop: :environment do
    Rake::Task['sidekiq:sidekiqctl'].invoke('stop', '10')
  end

  task before: :environment do
    RAILS_ENV = (ENV['RAILS_ENV'] || 'development').dup unless defined?(RAILS_ENV)
  end

  task start: :before
  task sidekiqctl: :before
end
