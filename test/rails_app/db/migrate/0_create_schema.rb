class CreateSchema < ActiveRecord::Migration
  def change
    create_table "users", force: :cascade do |t|
      t.string "name"
    end
  end
end
