class QuestionCloner

  def self.clone(question)
    question.dup.tap do |new_question|
      question.answers.each do |answer|
        new_question.answers << answer.dup
      end
    end
    # new_question = question.dup
    # question.answers.each do |answer|
    #   new_question.answers << answer.dup
    # end
    # new_question
  end

end
