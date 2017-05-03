class CreateTableMigration < ActiveRecord::Migration[4.2]
  def change
    create_table :users, force: true do |t|
      t.string :name
    end
  end
end
