class AddStatusToCheatsheet < ActiveRecord::Migration
  def change
    add_reference :cheatsheets, :status, index: true
  end
end
