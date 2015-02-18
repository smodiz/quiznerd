class RemoveStatusFromCheatsheets < ActiveRecord::Migration
  def up
    remove_column :cheatsheets, :status_id
  end

  def down
    add_column :cheatsheets, :status_id
  end
end
