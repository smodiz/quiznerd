class QuizMerge 
  include ActiveModel::Model

  attr_accessor :target_quiz_id, :source_quiz_id, :user

  validates :target_quiz_id, :source_quiz_id, :user, presence: true
  validate :ids_not_equal
  validate :user_id_matches



  def self.mergable_quizzes_for(user)
    Quiz.where(author: user)
  end

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      update_quiz_events
      merge_questions
      destroy_source_quiz
    end
  end

  def target_quiz
    if target_quiz_id.present?
      @target_quiz ||= Quiz.find(target_quiz_id)
    end
  end

  private 

  def merge_questions
    source_quiz.questions.update_all(quiz_id: target_quiz_id)
  end

  def update_quiz_events
    quiz_events = QuizEvent.where(quiz_id: source_quiz_id)
    quiz_events.update_all(quiz_id: target_quiz_id)
  end

  def source_quiz
    if source_quiz_id.present?
      @source_quiz ||= Quiz.find(source_quiz_id)
    end
  end

  def destroy_source_quiz
    Quiz.find(source_quiz_id).destroy
  end

  def ids_not_equal
    if source_quiz_id == target_quiz_id
      errors.add(:target_quiz_id, "cannot be equal to the source")
    end
  end

  def user_id_matches
    return unless user.present? && 
                  source_quiz_id.present? && 
                  target_quiz_id.present?

    if source_quiz.author.id  !=  target_quiz.author.id || 
      target_quiz.author.id   !=  user.id
      errors.add(:base, "You must own the quizzes to be merged")
    end
  end

end
