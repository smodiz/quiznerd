# QuizTakingPresenter has view logic that was extracted
# from QuizTakingForm.
class QuizTakingPresenter < BasePresenter
  presents :quiz_taking_form

  def long_score
    "You scored #{GradePresenter.long_score(quiz_event.grade)}!"
  end

  def show_graded_question?
    quiz_taking_form.graded_question.present?
  end

  def grade_header
    result = answer_correct? ? 'Correct' : 'Incorrect'
    h.content_tag(:span, "#{result}!", class: result.downcase)
  end

  def remarks?
    quiz_taking_form.graded_question.remarks.present?
  end

  def grade_icon_for(answer)
    if answer.correct?
      correct_icon
    elsif graded_answer_ids.include?(answer.id)
      incorrect_icon
    end
  end

  def question_number
    quiz_event.total_answered + 1
  end

  def multi_select?
    question.question_type == 'MC-2'
  end

  def self.clear_history_link(context)
    context.link_to \
      "<i class='#{Icon::CLEAR_HISTORY}'></i> Reset History".html_safe,
      context.clear_quiz_events_history_path,
      method: :delete,
      data: {
        confirm: 'Are you sure you want to delete your quiz taking history?'
      },
      class: 'btn btn-danger pull-right btn-sm'
  end

  def self.clear_link_command
    'QuizTakingPresenter.clear_history_link(self) unless @quiz_events.empty?'
  end

  private

  def correct_icon
    h.content_tag(
      :span,
      '',
      class: "grade icon correct #{Icon::CORRECT}")
  end

  def incorrect_icon
    h.content_tag(
      :span,
      '',
      class: "grade icon incorrect #{Icon::INCORRECT}")
  end
end
