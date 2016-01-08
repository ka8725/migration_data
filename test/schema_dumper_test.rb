require 'test_helper'
require 'migration_data/active_record/schema_dumper'

describe MigrationData::ActiveRecord::SchemaDumper do
  before do
    CreateTableMigration.new.migrate(:up)
  end

  describe '#dump' do
    it 'squashes the schema' do
      stream = MigrationData::ActiveRecord::SchemaDumper.dump
      assert_equal <<-SCHEMA, stream.string
  create_table \"users\", force: #{FORCE_MIGRATION} do |t|
    t.string \"name\"
  end

      SCHEMA
    end
  end
end
