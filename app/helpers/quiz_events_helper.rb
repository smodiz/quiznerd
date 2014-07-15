module QuizEventsHelper

  def answer_shown_already?
    # when you present a question, you show the previous answer at the 
    # same time. If the new question fails validaton, the page reloads 
    # but the previous answers are no longer available
    !@quiz_event.last_answer_ids
  end

end
