class Quiz < ActiveRecord::Base
  include QuizFinder

  belongs_to  :category
  belongs_to  :subject
  belongs_to  :author, class_name: "User"
  has_many    :questions, dependent: :destroy
  has_many    :quiz_events, dependent: :destroy
  
  attr_accessor :new_category, :new_subject
  
  validates :name, :description, :author, presence: true
  validates :name, length: { maximum: 45 }
  validates :description, length: { maximum: 255 }
  validates :published, inclusion: { in: [true, false] }
  validates :category_id, :category_present => true
  validates :subject_id, :subject_present => true

  delegate :name, :to => :category, :prefix => true, :allow_nil => true
  delegate :name, :to => :subject, :prefix => true, :allow_nil => true

  before_save   ->{ CategoryCreator.new(self).create }, if: -> { :new_category.present? }
  before_save   ->{ SubjectCreator.new(self).create }, if: -> { :new_subject.present? }

  after_touch       :unpublish_when_last_question_removed
  after_initialize  :set_defaults
  


  def self.new_for_user(user)
    user.quizzes.build
  end

  def self.with_questions_and_answers(id)
    Quiz.includes(:category, :subject, questions: [:answers]).find(id)
  end

  def number_of_questions
    questions.size
  end

  def can_publish?
    number_of_questions >= 1
  end

  def toggle_publish
    if published
      self.toggle(:published)   # can unpublish at will
    elsif can_publish?  # but publishing requires validation
      self.toggle(:published)
    end
  end
  
  def next_question_id(last_question_id)
    if last_question_id
      questions.where("id > ?", last_question_id).first.try(:id)
    else
      first_question_id
    end
  end

  def first_question_id
    questions.first.id 
  end

  protected
  
  def unpublish_when_last_question_removed
    if questions.size == 0 && published
      self.update_attributes(published: false)
    end
  end

  def set_defaults
    self.published = false if self.published.nil?
  end
end
