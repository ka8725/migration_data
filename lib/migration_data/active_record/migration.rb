module MigrationData
  module ActiveRecord
    module Migration
      def self.included(base)
        base.class_eval do
          def exec_migration_with_data(conn, direction)
            origin_exec_migration(conn, direction)
            unless ENV['RAILS_ENV'] == 'test'
              data if direction == :up && respond_to?(:data)
              rollback if direction == :down && respond_to?(:rollback)
            end
          end

          alias origin_exec_migration exec_migration
          alias exec_migration exec_migration_with_data
        end
      end
    end
  end
end
