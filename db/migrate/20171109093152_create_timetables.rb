class CreateTimetables < ActiveRecord::Migration[5.1]
  def change
    drop_table(:timetables)
    create_table :timetables do |t|
      t.string :date
      t.string :group_name
      t.string :title
      t.string :url
    end
  end
end
