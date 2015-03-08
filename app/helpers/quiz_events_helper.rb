module QuizEventsHelper

  def user_owns_quiz?
    @quiz_event.quiz.author == current_user
  end

  def quiz_still_public?
    @quiz_event.quiz.published
  end
end
