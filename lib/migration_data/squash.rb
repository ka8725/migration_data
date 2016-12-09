require 'migration_data/active_record/schema_dumper'

module MigrationData
  class Squash
    def call
      remove_all_old_migrations
      squash_schema
    end

    private

    def squash_schema
      File.open(migration_file_name, 'w') do |f|
        content =
        <<-MIGRATION.gsub(/^ {10}/, '')
          class CreateSchema < ActiveRecord::Migration
            def change
            #{MigrationData::ActiveRecord::SchemaDumper.dump.string.strip.gsub(/^/, '  ')}
            end
          end
        MIGRATION

        f.write(content)
      end
    end

    def remove_all_old_migrations
      migration_dirs.each do |dir|
        FileUtils.rm_rf(Dir.glob(File.join(dir, '**/*.rb')))
      end
    end

    def current_version
      ::ActiveRecord::Migrator.current_version
    end

    def migration_dirs
      MigrationData::ActiveRecord::Migration.migration_dirs
    end

    def migration_dir
      MigrationData::ActiveRecord::Migration.migration_dir
    end

    def migration_file_name
      File.join(migration_dir, "#{current_version}_create_schema.rb")
    end
  end
end
