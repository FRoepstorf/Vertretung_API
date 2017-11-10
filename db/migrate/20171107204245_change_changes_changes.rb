class ChangeChangesChanges < ActiveRecord::Migration[5.1]
  def change
    rename_column :changes, :class_room, :school_class
  end
end
