require 'test_helper'

class MyMigration < ActiveRecord::Migration[4.2]
  attr_reader :migrated_data, :rolled_back_data

  def data
    @migrated_data = true
  end

  def rollback
    @rolled_back_data = true
  end
end

describe MyMigration do
  before do
    @migration = MyMigration.new
  end

  describe '#migrate' do
    it 'runs #data on up direction' do
      @migration.migrate(:up)
      assert @migration.migrated_data
    end

    it "doesn't run #data on down direction" do
      @migration.migrate(:down)
      assert_nil @migration.migrated_data
    end

    it 'runs #rollback on down direction' do
      @migration.migrate(:down)
      assert @migration.rolled_back_data
    end

    it "doesn't run #rollback on up direction" do
      @migration.migrate(:up)
      assert_nil @migration.rolled_back_data
    end
  end
end
