class QuestionCloner

  def self.clone(question)
    new_question = Cloner.clone(question)
    question.answers.each do |answer|
      new_question.answers << Cloner.clone(answer)
    end
    new_question

  end

end
