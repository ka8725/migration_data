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
            data_before if should_run?(direction == :up, :data_before)
            rollback_before if should_run?(direction == :down, :rollback_before)

            origin_exec_migration(conn, direction)
            ::ActiveRecord::Base.connection.schema_cache.clear!

            data if should_run?(direction == :up, :data)
            data_after if should_run?(direction == :up, :data_after)
            rollback if should_run?(direction == :down, :rollback)
            rollback_after if should_run?(direction == :down, :rollback_after)
          end

          alias origin_exec_migration exec_migration
          alias exec_migration exec_migration_with_data

          private

          def should_run?(is_ok_direction, method_name)
            is_ok_direction && !MigrationData.config.skip && respond_to?(method_name)
          end
        end
      end
    end
  end
end
