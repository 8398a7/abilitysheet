set :output, 'log/crontab.log'
set :enviroment, :production
set :job_template, "/bin/zsh -l -c ':job'"

# 毎日5時にDBのバックアップを取る
# every 1.day, at: '5:00 am' do
#   rake 'db:data:dump_backup RAILS_ENV=production'
# end
# テスト
# every 2.minutes do
#   rake 'db:data:dump_backup RAILS_ENV=production'
# end
