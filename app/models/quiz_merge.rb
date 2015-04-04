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
    @target_quiz ||= Quiz.find(target_quiz_id) if target_quiz_id.present?
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
    @source_quiz ||= Quiz.find(source_quiz_id) if source_quiz_id.present?
  end

  def destroy_source_quiz
    Quiz.find(source_quiz_id).destroy
  end

  def ids_not_equal
    errors.add(:target_quiz_id, 'cannot be equal to the source') if same_quiz?
  end

  def same_quiz?
    source_quiz_id == target_quiz_id
  end

  def user_id_matches
    return unless data_present?
    errors.add(:base, 'You must own the quizzes to be merged') if mismatch_user?
  end

  def mismatch_user?
    different_user? || different_author?
  end

  def different_user?
    target_quiz.author.id !=  user.id
  end

  def different_author?
    source_quiz.author.id  !=  target_quiz.author.id
  end

  def data_present?
    user.present? &&
      source_quiz_id.present? &&
      target_quiz_id.present?
  end
end
