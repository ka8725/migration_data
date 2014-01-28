require 'migration_data/version'

module MigrationData
  def exec_migration(conn, direction)
    super
    if direction == :up && respond_to?(:data)
      data
    end
  end
end

ActiveRecord::Migration.prepend(MigrationData)
