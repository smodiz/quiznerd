module QuizEventsHelper

  def user_owns_quiz?
    @quiz_event.quiz.author == current_user
  end
end
