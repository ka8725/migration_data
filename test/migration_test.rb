require 'test_helper'

class MyMigration < ActiveRecord::Migration[4.2]
  attr_reader :migrated_data_before,
              :migrated_data,
              :migrated_data_after,
              :rolled_back_data_before,
              :rolled_back_data,
              :rolled_back_data_after

  def data_before
    @migrated_data_before = true
  end

  def data
    @migrated_data = true
  end

  def data_after
    @migrated_data_after = true
  end

  def rollback_before
    @rolled_back_data_before = true
  end

  def rollback
    @rolled_back_data = true
  end

  def rollback_after
    @rolled_back_data_after = true
  end
end

describe MyMigration do
  before do
    @migration = MyMigration.new
  end

  describe '#migrate' do
    it 'runs #data on up direction' do
      @migration.migrate(:up)
      assert @migration.migrated_data_before
      assert @migration.migrated_data
      assert @migration.migrated_data_after
    end

    it "doesn't run #data on down direction" do
      @migration.migrate(:down)
      assert_nil @migration.migrated_data_before
      assert_nil @migration.migrated_data
      assert_nil @migration.migrated_data_after
    end

    it 'runs #rollback on down direction' do
      @migration.migrate(:down)
      assert @migration.rolled_back_data_before
      assert @migration.rolled_back_data
      assert @migration.rolled_back_data_after
    end

    it "doesn't run #rollback on up direction" do
      @migration.migrate(:up)
      assert_nil @migration.rolled_back_data_before
      assert_nil @migration.rolled_back_data
      assert_nil @migration.rolled_back_data_after
    end

    describe 'when skipping' do
      before do
        @old_skip, MigrationData.config.skip = MigrationData.config.skip, true
      end

      after do
        MigrationData.config.skip = @old_skip
      end

      it "doesn't runs #data" do
        @migration.migrate(:up)
        refute @migration.migrated_data
      end

      it "doesn't runs #rollback" do
        @migration.migrate(:down)
        refute @migration.rolled_back_data
      end
    end
  end
end
