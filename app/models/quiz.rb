class Quiz < ActiveRecord::Base
  include QuizFinder

  belongs_to  :category
  belongs_to  :subject
  belongs_to  :author, class_name: "User"
  has_many    :questions, dependent: :destroy
  has_many    :quiz_events, dependent: :destroy
  
  validates :author, :category_id, :subject_id, presence: true
  validates :name, presence: true, length: { maximum: 45 }
  validates :description, presence: true, length: { maximum: 255 }
  validates :published, inclusion: { in: [true, false] }

  delegate :name, :to => :category, :prefix => true, :allow_nil => true
  delegate :name, :to => :subject, :prefix => true, :allow_nil => true

  after_touch       :unpublish_when_last_question_removed
  after_initialize  :set_defaults
  after_commit      :invalidate_cache
  after_destroy     :invalidate_cache
 

  def number_of_questions
    questions.size
  end

  def can_publish?
    number_of_questions >= 1
  end

  def toggle_publish
    self.toggle(:published) if published || (!published && can_publish?)
  end

  private
  
  def unpublish_when_last_question_removed
    if questions.reload.length == 0 && published
      self.update_attributes(published: false)
    end
  end

  def set_defaults
    self.published = false if self.published.nil?
  end

  def invalidate_cache
    Rails.cache.delete(Quiz.quizzes_cache_key(author))
  end

end
