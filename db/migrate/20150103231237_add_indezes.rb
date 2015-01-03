class AddIndezes < ActiveRecord::Migration
  def change
    remove_index :taggings, :taggable_type
    add_index :taggings, [:taggable_type, :taggable_id]
    add_index :quizzes, :author_id
  end
end
