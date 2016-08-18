namespace :db do
  task migrate: :environment do
    Rake::Task['db:migrate'].invoke
    `erd --attributes=foreign_keys,primary_keys,content,timestamp --filename=docs/erd --filetype=png`
  end
end
