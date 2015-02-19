class QuestionCloner

  def self.clone(question)
    new_question = question.dup
    question.answers.each do |answer|
      new_question.answers << answer.dup
    end
    new_question
  end

end
