# A quiz event is the name for a quiz that has
# been taken by a user. Only the end result
# is recorded (i.e. the user who took the quiz,
# which quiz they took, how many questions did
# they get right, etc)
class QuizEvent < ActiveRecord::Base
  include QuizEventFinder
  include Gradeable

  belongs_to :user
  belongs_to :quiz
  after_commit :invalidate_cache
  after_destroy :invalidate_cache
  has_one :subject, through: :quiz
  has_one :category, through: :quiz

  default_scope -> { order('created_at DESC') }

  COMPLETED_STATUS = 'Completed'

  def cached_quiz
    @quiz ||= Rails.cache.fetch(['quiz_event/quiz', quiz_id, id]) do
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
    status == QuizEvent::COMPLETED_STATUS
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
