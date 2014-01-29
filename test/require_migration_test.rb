require 'test_helper'
require 'migration_data/testing'

describe '#require_migration' do
  let(:db_path) do
    test_dir = File.expand_path(File.dirname(__FILE__))
    File.join(test_dir, 'db')
  end

  it 'loads existed migation' do
    ActiveRecord::Migrator.stub(:migrations_path, db_path) do
      require_migration 'test_migration'
    end
  end

  it 'raises exception on load unexisted migration' do
    ActiveRecord::Migrator.stub(:migrations_path, db_path) do
      assert_raises LoadError, 'cannot load such file -- test_migration2.rb' do
        require_migration('test_migration2')
      end
    end
  end
end