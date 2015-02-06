class CreateFlashCards < ActiveRecord::Migration
  def change
    create_table :flash_cards do |t|
      t.text :front
      t.text :back
      t.integer :sequence
      t.string :difficulty
      t.references :deck, index: true

      t.timestamps
    end
    add_index :flash_cards, :sequence
  end
end
