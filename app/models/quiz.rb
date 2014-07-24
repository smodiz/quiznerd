class Quiz < ActiveRecord::Base
  include QuizFinder

  belongs_to :category
  belongs_to :subject
  belongs_to :author, class_name: "User"
  has_many :questions, dependent: :destroy
  has_many :quiz_events, dependent: :nullify

  validates :name, :description, :author, :category, :subject, presence: true
  validates :published, inclusion: { in: [true, false] }

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

  
end
