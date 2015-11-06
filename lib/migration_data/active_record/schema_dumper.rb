module MigrationData
  module ActiveRecord
    class SchemaDumper < ::ActiveRecord::SchemaDumper
      def self.dump(connection=::ActiveRecord::Base.connection, stream=StringIO.new, config = ::ActiveRecord::Base)
        new(connection, generate_options(config)).dump(stream)
        stream
      end

      def dump(stream)
        extensions(stream)
        tables(stream)
        stream
      end
    end
  end
end
