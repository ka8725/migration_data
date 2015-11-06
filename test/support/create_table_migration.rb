class CreateTableMigration < ActiveRecord::Migration
  def change
    create_table :users, force: true do |t|
      t.string :name
    end
  end
end
