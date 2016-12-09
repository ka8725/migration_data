module MigrationData
  module ActiveRecord
    module Migration
      class << self
        def migration_dirs
          ::ActiveRecord::Tasks::DatabaseTasks.migrations_paths
        end

        def migration_dir
          migration_dirs.first
        end
      end

      def self.included(base)
        base.class_eval do
          def exec_migration_with_data(conn, direction)
            origin_exec_migration(conn, direction)
            data if direction == :up && respond_to?(:data)
            rollback if direction == :down && respond_to?(:rollback)
          end

          alias origin_exec_migration exec_migration
          alias exec_migration exec_migration_with_data
        end
      end
    end
  end
end
