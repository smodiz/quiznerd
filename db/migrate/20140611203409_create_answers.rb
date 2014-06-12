class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :content
      t.references :question, index: true
      t.boolean :correct

      t.timestamps
    end
  end
end
