module QuizMergesHelper

  def mergable_quizzes_select
    @quizzes ||= QuizMerge.mergable_quizzes_for(current_user).
      map { |q| [q.name, q.id] }
  end

end
