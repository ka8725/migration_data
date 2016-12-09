require 'test_helper'
require 'migration_data/testing'

describe '#require_migration' do
  let(:db_path) do
    test_dir = File.expand_path(File.dirname(__FILE__))
    Pathname(File.join(test_dir, 'db'))
  end

  it 'loads existed migation' do
    Rails.stub(:root, db_path) do
      MigrationData::ActiveRecord::Migration.stub(:migration_dir, db_path) do
        require_migration 'test_migration'
      end
    end
  end

  it 'raises exception on load unexisted migration' do
    MigrationData::ActiveRecord::Migration.stub(:migration_dir, db_path) do
      assert_raises LoadError, 'cannot load such file -- test_migration2.rb' do
        require_migration('test_migration2')
      end
    end
  end
end
