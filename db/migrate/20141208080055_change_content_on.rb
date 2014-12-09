class ChangeContentOn < ActiveRecord::Migration
  def change
    change_column :cheatsheets, :content, :text
  end
end
