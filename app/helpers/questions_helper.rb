module QuestionsHelper

  def correct_answer_checkmark
    content_tag(:span,"", class: "grade icon glyphicon glyphicon-ok")
  end
end
