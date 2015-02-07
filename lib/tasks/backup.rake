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
            File.new("#{ dirname }/data.#{ @extension }", 'w')
          )
        end
      end
    end

    def backup_dir
      "#{ Rails.root }/tmp/abilitysheet_backup"
    end

    def git_checkout(env)
      system("/bin/zsh -l -c \"cd #{ backup_dir } && git checkout #{ env }\"")
    end

    def git_exec(env)
      command = %(git add -A && git commit -m '[#{ env }] backup update' && git push origin #{ env })
      system("/bin/zsh -l -c \"cd #{ backup_dir } && #{ command }\"")
    end

    def env_init(env)
      return env if ENV['RAILS_ENV']
      'development'
    end

    desc 'Dump contents of database to curr_dir_name/tablename.extension (defaults to yaml)'
    task dump_backup: :environment do
      env = env_init(ENV['RAILS_ENV'])
      git_checkout(env)
      format_class = ENV['class'] || 'YamlDb::Helper'
      SerializationHelper::Base.new(format_class.constantize).dump_to_backup backup_dir
      git_exec(env)
    end

    desc 'Load contents of db/data_dir into database'
    task load_backup: :environment do
      env = env_init(ENV['RAILS_ENV'])
      git_checkout(env)
      format_class = ENV['class'] || 'YamlDb::Helper'
      SerializationHelper::Base.new(format_class.constantize).load_from_dir backup_dir
    end
  end
end
