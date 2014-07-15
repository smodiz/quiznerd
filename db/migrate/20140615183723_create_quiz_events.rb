class CreateQuizEvents < ActiveRecord::Migration
  def change
    create_table :quiz_events do |t|
      t.references :user, index: true
      t.references :quiz, index: true
      t.string :status, index: true, default: "In Progress"
      t.integer :total_correct, default: 0
      t.integer :total_answered, default: 0
      t.integer :last_question_id
      t.timestamps
    end
  end
end
