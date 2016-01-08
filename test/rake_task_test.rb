require 'test_helper'
require 'migration_data/squash'

describe 'db:schema:squash' do
  let(:rake) { Rake::Application.new }

  before do
    CreateTableMigration.new.migrate(:up)
    Rake.application = rake
    Rake.application.rake_require('db', [File.expand_path('../../lib/tasks', __FILE__)])
  end

  describe '#invoke' do
    it 'squashes the schema to the current migration' do
      latest_migration = Rails.root.join('db', 'migrate', '0_create_schema.rb')
      FileUtils.rm(latest_migration) if File.exist?(latest_migration)

      Rake::Task['db:migrate:squash'].invoke
      assert_equal <<-MIGRATION, File.read(latest_migration)
class CreateSchema < ActiveRecord::Migration
  def change
    create_table \"users\", force: #{FORCE_MIGRATION} do |t|
      t.string \"name\"
    end
  end
end
      MIGRATION
    end
  end
end
