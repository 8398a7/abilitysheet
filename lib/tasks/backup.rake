namespace :db do
  desc 'Dump schema and data to db/schema.rb and db/data.yml'
  task(dump: ['db:schema:dump', 'db:data:dump'])

  desc 'Load schema and data from db/schema.rb and db/data.yml'
  task(load: ['db:schema:load', 'db:data:load'])

  namespace :data do
    def db_dump_data_file(extension = 'yml')
      "#{ backup_dir }/data.#{ extension }"
    end

    def backup_dir
      "#{Rails.root}/tmp/abilitysheet_backup"
    end

    desc 'Dump contents of database to curr_dir_name/tablename.extension (defaults to yaml)'
    task dump_backup: :environment do
      format_class = ENV['class'] || 'YamlDb::Helper'
      SerializationHelper::Base.new(format_class.constantize).dump_to_dir backup_dir
    end

    desc 'Load contents of db/data_dir into database'
    task load_backup: :environment do
      format_class = ENV['class'] || 'YamlDb::Helper'
      SerializationHelper::Base.new(format_class.constantize).load_from_dir backup_dir
    end
  end
end
