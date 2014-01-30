def require_migration(migration_name)
  path = ActiveRecord::Migrator.migrations_path
  all_migrations = ActiveRecord::Migrator.migrations(path)

  migration_name += '.rb' unless migration_name.end_with?('.rb')
  file = all_migrations.detect do |m|
    m.filename.end_with?(migration_name)
  end

  raise LoadError, "cannot load such file -- #{migration_name}" unless file

  require Rails.root.join(file.filename)
end
