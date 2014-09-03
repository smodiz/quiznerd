class Quiz < ActiveRecord::Base
  include QuizFinder

  belongs_to :category
  belongs_to :subject
  belongs_to :author, class_name: "User"
  has_many :questions, dependent: :destroy
  has_many :quiz_events, dependent: :nullify
  attr_accessor :new_category, :new_subject
  
  validates_with CategorySubjectValidator
  validates :name, :description, :author, presence: true
  validates :name, length: { maximum: 45 }
  validates :description, length: { maximum: 255 }
  validates :published, inclusion: { in: [true, false] }

  before_save :create_category_subject, if: -> { :new_subject.present? }
  after_touch :check_published_flag
  after_initialize :set_defaults
  


  def self.new_for_user(user, params)
    quiz = Quiz.new(params)
    quiz.author = user
    quiz
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
      questions.first.id 
    end
  end

  def category_name
    category.present? ? category.name : ""
  end

  def subject_name
    subject.present? ? subject.name : ""
  end

  def create_category_subject
    CategorySubjectCreator.new(self).create
  end

  protected
  
  def check_published_flag
    if questions.size == 0
      self.published = false
      self.save!
    end
  end

  def set_defaults
    self.published = false if self.published.nil?
  end
end
