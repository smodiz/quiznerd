class QuizEvent < ActiveRecord::Base
  include QuizEventFinder
  include Gradeable

  belongs_to    :user
  belongs_to    :quiz
  after_commit  :invalidate_cache
  after_destroy :invalidate_cache
  
  default_scope -> { order('created_at DESC') }
   
  COMPLETED_STATUS    = "Completed"
  IN_PROGRESS_STATUS  = "In Progress"
  
  def cached_quiz
    # cached for use by this single quiz event
    quiz = Rails.cache.fetch(["quiz_event/quiz", quiz_id, id]) do
      Quiz.with_questions_and_answers(quiz_id) 
    end 
  end

  def category_name
    cached_quiz.category.name
  end
  
  def subject_name
    cached_quiz.subject.name
  end

  def quiz_name
    cached_quiz.name
  end

  def quiz_description
    cached_quiz.description
  end

  def number_of_questions
    cached_quiz.number_of_questions
  end

  def completed?
    self.status == QuizEvent::COMPLETED_STATUS
  end

  def total_answered=(value)
    self[:total_answered] = value
    complete if last_question_answered?
  end



private

  def complete
    self.status = QuizEvent::COMPLETED_STATUS
  end

  def last_question_answered?
    if data_present?
      total_answered == number_of_questions
    else
      false
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

  def invalidate_cache
    Rails.cache.delete(QuizEvent.quiz_events_cache_key(user))
  end

end
