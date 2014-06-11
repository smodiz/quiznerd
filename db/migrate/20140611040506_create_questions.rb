class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :question_type
      t.text :content
      t.text :remarks
      t.references :quiz, index: true

      t.timestamps
    end
  end
end
