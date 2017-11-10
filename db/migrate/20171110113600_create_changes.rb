class CreateChanges < ActiveRecord::Migration[5.1]
  def change
    create_table "changes", force: :cascade do |t|
      t.string "school_class"
      t.string "hours"
      t.string "room"
      t.string "description"
      t.string "date"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
