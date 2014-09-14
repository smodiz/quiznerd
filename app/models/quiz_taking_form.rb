=begin 

QuizTakingForm is a form model to handle interactions with the user
during a quiz, i.e. serving up each question, in turn, and showing 
the user their graded answer. Much of this interaction is NOT persisted
so this logic was extracted from the QuizEvent model, which is now left
with only the high level data that IS persisted, such as which quiz a user 
took, and their overall score.

=end

class QuizTakingForm
  include ActiveModel::Model 

  validates :answer_ids, presence: true

  attr_accessor :quiz_event, :quiz, 
                :question_id, :question, :answer_ids,
                :graded_question, :graded_answer_ids
  attr_reader   :view_context

  def initialize(options={})
    @quiz_event     = options[:quiz_event]
    @quiz           = @quiz_event.quiz
    @view_context   = options[:view_context] 
    @answer_correct = nil

    if starting_quiz?
      self.question_id = quiz.first_question_id
    end
  end

  def persisted?
    true
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "QuizEvent")
  end

  def submit(params)
    self.answer_ids = params[:answer_ids]
    self.question_id = params[:question_id]

    if user_cheating? || !valid?
      false      
    else
      grade_question
      advance_to_next
      quiz_event.save
    end
  end

  def question_number
    quiz_event.total_answered + 1
  end

  def show_graded_question?
    graded_question.present?
  end

  def multi_select?
    question.question_type == "MC-2"
  end

  def has_remarks?
    graded_question.remarks.present? 
  end

  def grade_icon_for(answer)
    if answer.correct?
      view_context.content_tag(:span, "&#x2713".html_safe, class: "grade icon correct")
    elsif graded_answer_ids.include?(answer.id)
      view_context.content_tag(:span, "&#x2717".html_safe, class: "grade icon incorrect")
    end
  end

  def grade_header
    result = answer_correct? ? "Correct" : "Incorrect"
    view_context.content_tag(:span, "#{result}!", class: result.downcase)
  end

  def quiz_completed?
    quiz_event.completed?
  end

  def question
    @question ||= 
      if question_id.blank?
        nil
      else
        quiz.questions.find(question_id)
      end
  end

  def id
    quiz_event.id
  end

  def answer_correct?
    if @answer_correct.nil?
      @answer_correct = question.correct_answer?(answer_ids)
    end  
    @answer_correct 
  end

private

  def starting_quiz?
    quiz_event.total_answered == 0 && question_id.blank?
  end

  def grade_question
    quiz_event.total_correct += 1 if answer_correct?
    quiz_event.total_answered += 1
    self.graded_question = question
    self.graded_answer_ids = answer_ids
  end

 

  def advance_to_next
    quiz_event.last_question_id = question_id
    self.question_id = next_question_id
    self.answer_ids = nil
    self.question = nil
  end

  def next_question_id 
    quiz.next_question_id(quiz_event.last_question_id)
  end

  def user_cheating?   
    if user_modifying_completed_test? || user_re_answering_question?
      true
    else
      false
    end
  end

  def user_modifying_completed_test?
    if quiz_event.completed?
      self.errors.add(:base, 
        "Can't re-answer questions. Quiz already completed.")
      true
    else
      false
    end
  end

  def user_re_answering_question?
    if question_out_of_order?
      self.errors.add(:question_id, 
        "cannot be answered more than once. Please answer the next question:")
      self.question_id = next_question_id
      true
    else
      false
    end
  end

  def question_out_of_order?
    if question_id.present? && quiz_event.last_question_id.present?
      question_id.to_i <= quiz_event.last_question_id.to_i
    else
      false
    end
  end

end