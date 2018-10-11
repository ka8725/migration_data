require 'rails'

def require_migration(migration_name)
  path = MigrationData::ActiveRecord::Migration.migration_dir
  migrations = all_migrations(path)

  migration_name += '.rb' unless migration_name.end_with?('.rb')
  file = migrations.detect do |m|
    m.filename.end_with?(migration_name)
  end

  raise LoadError, "cannot load such file -- #{migration_name}" unless file

  require Rails.root.join(file.filename)
end

def all_migrations(path)
  if Rails::VERSION::MAJOR >= 5 && Rails::VERSION::MINOR >= 2
    ActiveRecord::MigrationContext.new(path).migrations
  else
    ActiveRecord::Migrator.migrations(path)
  end
end
