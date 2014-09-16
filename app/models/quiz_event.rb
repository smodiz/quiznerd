class QuizEvent < ActiveRecord::Base
  include QuizEventFinder

  belongs_to :user
  belongs_to :quiz
  has_one :subject, through: :quiz 
  has_one :category, through: :quiz
  delegate :name, to: :category, prefix: true
  delegate :name, to: :subject, prefix: true
  delegate :name, :description, to: :quiz, prefix: true

  default_scope -> { order('created_at DESC') }
   
  COMPLETED_STATUS = "Completed"
  IN_PROGRESS_STATUS = "In Progress"
  
  def number_of_questions
    quiz.number_of_questions
  end

  def current_percent_grade
    if data_present?
      (total_correct.to_f / total_answered.to_f) * 100
    else
      0
    end
  end

  def completed?
    self.status == QuizEvent::COMPLETED_STATUS
  end

  def total_answered=(value)
    self[:total_answered] = value
    update_status if self[:total_answered] && self[:total_answered] > 0
  end

private

  def update_status
    if total_answered == number_of_questions
      self.status = QuizEvent::COMPLETED_STATUS
    end
  end

  def data_present?
    if  total_answered.present? && 
        total_correct.present? && 
        total_answered > 0
      true
    else
      false
    end
  end
end
