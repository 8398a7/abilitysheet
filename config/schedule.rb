env :PATH, ENV['PATH']
set :output, ENV['CRON_LOG_FILE']
set :enviroment, :production
set :job_template, "/bin/zsh -l -c ':job'"

# 毎日5時にDBのバックアップを取る
every 1.day, at: '5:00 am' do
  rake 'db:data:s3_backup'
end
