namespace :db do
  desc 'Dump schema and data to db/schema.rb and db/data.yml'
  task(dump: ['db:schema:dump', 'db:data:dump'])

  desc 'Load schema and data from db/schema.rb and db/data.yml'
  task(load: ['db:schema:load', 'db:data:load'])

  namespace :data do
    task s3_backup: :environment do
      Rake::Task['db:data:dump'].invoke
      s3 = Aws::S3::Client.new
      file_open = File.open("#{Rails.root}/db/data.yml")
      file_name = File.basename("abilitysheet_#{ENV['RAILS_ENV']}.yml")
      begin
        s3.put_object(
          bucket: 'abilitysheet',
          body: file_open,
          key: file_name
        )
        Slack::S3Dispatcher.success(ENV['RAILS_ENV'])
      rescue => ex
        Slack::S3Dispatcher.failed(ENV['RAILS_ENV'], ex)
      end
    end

    desc 'Load contents of db/data_dir into database'
    task load_backup: :environment do
      env = ENV['RAILS_ENV'] || 'production'
      system "aws s3 cp s3://abilitysheet/abilitysheet_#{env}.yml #{Rails.root}/db/data.yml"
      Rake::Task['db:data:load'].invoke
    end
  end
end
