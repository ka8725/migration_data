require 'test_helper'
require 'migration_data/active_record/schema_dumper'

class CreateTableMigration < ActiveRecord::Migration
  def change
    create_table :users, force: true do |t|
      t.string :name
    end
  end
end

describe MigrationData::ActiveRecord::SchemaDumper do
  before do
    CreateTableMigration.new.migrate(:up)
  end

  describe '#dump' do
    it 'squashes the schema' do
      stream = MigrationData::ActiveRecord::SchemaDumper.dump
      assert_equal <<-SCHEMA, stream.string
  create_table \"users\", force: :cascade do |t|
    t.string \"name\"
  end

      SCHEMA
    end
  end
end
