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
      s3 = Aws::S3::Encryption::Client.new
      file_open = File.open("#{backup_dir}/data.yml")
      file_name = File.basename("abilitysheet_#{ENV['RAILS_ENV']}.yml")
      uri = URI.parse(ENV['AWS_SLACK'])
      req = Net::HTTP::Post.new uri
      begin
        s3.put_object(
          bucket: 'abilitysheet',
          body: file_open,
          key: file_name
        )
        req.body = { text: "#{DateTime.now} production backup complete!" }.to_json

        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http.ssl_version = :SSLv3
          http.request req
        end
      rescue
        req.body = { text: "#{DateTime.now} production backup failed..." }.to_json

        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http.ssl_version = :SSLv3
          http.request req
        end
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
