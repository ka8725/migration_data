require 'test_helper'
require 'migration_data/squash'

describe MigrationData::Squash do
  let(:squash) { MigrationData::Squash.new }
  let(:db_path) { Rails.root.join('db', 'migrate') }

  before do
    CreateTableMigration.new.migrate(:up)
  end

  describe '#call' do
    it 'squashes the schema to the current migration' do
      squash.stub(:current_version, '100500') do
        squash.call
      end
      assert_equal <<-MIGRATION, File.read(db_path.join('100500_create_schema.rb'))
class CreateSchema < ActiveRecord::Migration
  def change
    create_table \"users\", force: #{FORCE_MIGRATION} do |t|
      t.string \"name\"
    end
  end
end
      MIGRATION
    end

    it 'removes all the old migrations' do
      old_migration = db_path.join('100500_old_migration.rb')
      File.write(old_migration, '')

      assert_equal true, File.exist?(old_migration)

      squash.call

      assert_equal false, File.exist?(old_migration)
    end
  end
end
