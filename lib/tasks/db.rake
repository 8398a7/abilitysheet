namespace :db do
  task migrate: :environment do
    Rake::Task['db:migrate'].invoke
    Rake::Task['erd'].invoke
    `bundle exec annotate`
  end
end
