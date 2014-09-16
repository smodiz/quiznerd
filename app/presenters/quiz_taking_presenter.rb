class QuizTakingPresenter < BasePresenter

  presents :quiz_taking_form

  def show_graded_question?
    quiz_taking_form.graded_question.present?
  end

  def grade_header
    result = answer_correct? ? "Correct" : "Incorrect"
    h.content_tag(:span, "#{result}!", class: result.downcase)
  end
  
  def has_remarks?
    quiz_taking_form.graded_question.remarks.present? 
  end

  def grade_icon_for(answer)
    if answer.correct?
      h.content_tag(:span, "&#x2713".html_safe, 
        class: "grade icon correct")
    elsif graded_answer_ids.include?(answer.id)
      h.content_tag(:span, "&#x2717".html_safe, 
        class: "grade icon incorrect")
    end
  end

   def question_number
    quiz_event.total_answered + 1
  end

  def multi_select?
    question.question_type == "MC-2"
  end

  def quiz_result
    "You scored #{h.formatted_quiz_score(quiz_event)} \
     (#{quiz_event.total_correct}  out of \
       #{quiz_event.total_answered} )"
  end

end
