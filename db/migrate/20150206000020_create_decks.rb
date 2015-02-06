class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :name, limit: 45
      t.string :status
      t.text :description
      t.integer :flash_cards_count, default: 0
      t.integer :user_id

      t.timestamps
    end
    add_index :decks, :name
    add_index :decks, :status
    add_index :decks, :user_id
  end
end
