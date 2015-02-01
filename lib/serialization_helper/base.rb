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
