module QuizEventsHelper

  def formatted_quiz_score(quiz_event)
    "%.0f" % quiz_event.current_percent_grade
  end
end
