class CreateDeckEvents < ActiveRecord::Migration
  def change
    create_table :deck_events do |t|
      t.references :user, index: true
      t.references :deck, index: true
      t.integer :total_cards
      t.integer :total_correct
      t.text :missed_cards_list

      t.timestamps
    end
  end
end
