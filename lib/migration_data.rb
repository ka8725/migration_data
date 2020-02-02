require 'active_record'
require 'migration_data/version'
require 'migration_data/active_record/migration'
require 'migration_data/config'

ActiveRecord::Migration.send(:include, MigrationData::ActiveRecord::Migration)
