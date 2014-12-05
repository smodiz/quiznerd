class AddQuestionCountToQuiz < ActiveRecord::Migration
  def change
    add_column :quizzes, :questions_count, :integer, default: 0
    Quiz.reset_column_information
    Quiz.all.each do |quiz|
      quiz.update_attribute :questions_count, quiz.questions.length
    end
  end
end
