require 'active_record'
require 'migration_data/version'
require 'migration_data/active_record/migration'

require 'rake'
import File.join(File.dirname(__FILE__), 'tasks', 'db.rake')

ActiveRecord::Migration.send(:include, MigrationData::ActiveRecord::Migration)
