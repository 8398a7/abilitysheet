namespace :db do
  desc 'Dump schema and data to db/schema.rb and db/data.yml'
  task(dump: ['db:schema:dump', 'db:data:dump'])

  desc 'Load schema and data from db/schema.rb and db/data.yml'
  task(load: ['db:schema:load', 'db:data:load'])

  namespace :data do
    module SerializationHelper
      class Base
        def dump_to_backup(dirname)
          @dumper.dump(
            File.new("#{dirname}/data.#{@extension}", 'w')
          )
        end
      end
    end

    def backup_dir
      "#{Rails.root}/tmp/backup"
    end

    task s3_backup: :environment do
      format_class = ENV['class'] || 'YamlDb::Helper'
      SerializationHelper::Base.new(format_class.constantize).dump_to_backup backup_dir
      s3 = Aws::S3::Client.new
      file_open = File.open("#{backup_dir}/data.yml")
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
      system "aws s3 cp s3://abilitysheet/abilitysheet_#{ENV['RAILS_ENV']}.yml #{backup_dir}/data.yml"
      format_class = ENV['class'] || 'YamlDb::Helper'
      SerializationHelper::Base.new(format_class.constantize).load_from_dir backup_dir
    end
  end
end
