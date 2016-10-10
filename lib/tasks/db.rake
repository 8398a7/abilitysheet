namespace :db do
  task migrate: :environment do
    Rake::Task['db:migrate'].invoke
    Rake::Task['erd'].invoke unless Rails.env.production?
    `bundle exec annotate`
  end
end
