class QuizEvent < ActiveRecord::Base
  include QuizEventFinder

  belongs_to :user
  belongs_to :quiz
  has_one :subject, through: :quiz 
  has_one :category, through: :quiz
  
  before_save :process_question, on: :update 
  default_scope -> { order('created_at DESC') }
  validates :answer_ids, presence: true, on: :update 

  # these virtual attributes used for temporarily storing the 
  # current question_id and the user's answer, as well as their
  # answer to the last question so we can access the graded question
  attr_accessor :answer_ids, :question_id, :last_answer_ids, :last_answer_correct

  COMPLETED_STATUS = "Completed"
  IN_PROGRESS_STATUS = "In Progress"

  def process_question
    return false if user_cheating
    if before_first_question?
      set_question_id
    else
      grade_question
      advance_to_next
    end
  end

  def last_question
    quiz.questions.find(last_question_id)
  end

  def current_question
    quiz.questions.find(question_id)
  end

  def before_first_question?
    total_answered == 0 && !question_id
  end

  def reset
    set_question_id
  end

  def current_question_number
    total_answered + 1
  end

  def question(question_number)
    return quiz.questions[question_number - 1]
  end
  
  def number_of_questions
    quiz.number_of_questions
  end

  def current_percent_grade
    if total_answered && total_correct && total_answered > 0
      (total_correct.to_f / total_answered.to_f) * 100
    else
      0
    end
  end

  private

    def grade_question
      self.total_correct += 1 if  answer_correct?
      self.last_answer_correct = answer_correct?
      self.total_answered += 1
    end

    def advance_to_next
      self.last_question_id = question_id
      self.last_answer_ids = answer_ids
      self.answer_ids = nil
      set_question_id
      self.status = COMPLETED_STATUS if completed?
    end

    def completed?
      self.total_answered == self.quiz.questions.count
    end

    def set_question_id 
      self.question_id = quiz.next_question_id(last_question_id)
    end

    def answer_correct?
      current_question.correct_answer?(answer_ids)
    end

    def user_cheating   
      if user_modifying_completed_test || user_re_answering_question
        true
      else
        false
      end
    end

    def user_modifying_completed_test
      if status == COMPLETED_STATUS
        self.errors.add(:base, 
          "Can't re-answer questions. Quiz already completed.")
        return true
      end
      false
    end

    def user_re_answering_question
      if question_id && last_question_id && 
                question_id.to_i <= last_question_id.to_i
        self.errors.add(:question_id, 
          "cannot be answered more than once. Please answer the next question:")
        reset
        return true
      end
      false
    end
end
