class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :name
      t.string :description
      t.integer :author_id, index:true
      t.boolean :published, index:true
      t.references :category, index: true
      t.references :subject, index: true

      t.timestamps
    end
  end
end
