namespace :db do
  desc 'Dump schema and data to db/schema.rb and db/data.yml'
  task(dump: ['db:schema:dump', 'db:data:dump'])

  desc 'Load schema and data from db/schema.rb and db/data.yml'
  task(load: ['db:schema:load', 'db:data:load'])

  namespace :data do
    module SerializationHelper
      class Base
        def dump_to_backup(dirname)
          tables = @dumper.tables
          tables.each do |table|
            io = File.new "#{dirname}/#{table}.#{@extension}", 'w'
            @dumper.before_table(io, table)
            @dumper.dump_table io, table
            @dumper.after_table(io, table)
          end
        end
      end
    end

    def db_dump_data_file(extension = 'yml')
      "#{ backup_dir }/data.#{ extension }"
    end

    def backup_dir
      "#{ Rails.root }/tmp/abilitysheet_backup"
    end

    def git_checkout(env)
      system("/bin/zsh -l -c \"cd #{ backup_dir } && git checkout #{ env }\"")
    end

    def git_exec(env)
      git_checkout(env)
      command = %(git add -A && git commit -m '[#{ env }] backup update' && git push origin #{ env })
      system("/bin/zsh -l -c \"cd #{ backup_dir } && #{ command }\"")
    end

    desc 'Dump contents of database to curr_dir_name/tablename.extension (defaults to yaml)'
    task dump_backup: :environment do
      format_class = ENV['class'] || 'YamlDb::Helper'
      SerializationHelper::Base.new(format_class.constantize).dump_to_backup backup_dir
      sleep(20)
      git_exec(ENV['RAILS_ENV'])
    end

    desc 'Load contents of db/data_dir into database'
    task load_backup: :environment do
      format_class = ENV['class'] || 'YamlDb::Helper'
      SerializationHelper::Base.new(format_class.constantize).load_from_dir backup_dir
    end
  end
end
