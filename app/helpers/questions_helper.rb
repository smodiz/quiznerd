module QuestionsHelper
  def correct_answer_checkmark
    content_tag(:span, '', class: "#{Icon::CORRECT}")
  end
end
