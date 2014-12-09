class CreateCheatsheets < ActiveRecord::Migration
  def change
    create_table :cheatsheets do |t|
      t.string :title
      t.string :content
      t.boolean :published
      t.boolean :archived

      t.timestamps
    end
    add_index :cheatsheets, :title
  end
end
