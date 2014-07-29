class Quiz < ActiveRecord::Base
  include QuizFinder

  belongs_to :category
  belongs_to :subject
  belongs_to :author, class_name: "User"
  has_many :questions, dependent: :destroy
  has_many :quiz_events, dependent: :nullify

  validates :name, :description, :author, presence: true
  validates :name, length: { maximum: 45 }
  validates :description, length: { maximum: 255 }
  validates :published, inclusion: { in: [true, false] }
  validate  :new_category_requires_subject, :new_or_existing_category_required 
  validate  :new_or_existing_subject_required
  before_save :create_category, :create_subject
  after_touch :check_published_flag

  attr_accessor :new_category, :new_subject


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
  
  def create_category
    if new_category.present?
      self.category = Category.find_or_create_by!(name: new_category)
    end
  end

  def create_subject
    if new_subject.present?
      self.subject = Subject.find_or_create_by!(name: new_subject, category: category) 
    end
  end

  def new_category_requires_subject
    if new_category.present? && !new_subject.present?
      errors.add(:new_subject, "new category requires new subject")
    end
  end

  def new_or_existing_category_required
    if new_category.present? && category.present?
      errors.add(:category, "should be blank if new category selected")
    end
    if !new_category.present? && !category.present?
      errors.add(:category, "should be selected or a new category entered")
    end
  end

  def new_or_existing_subject_required
    if new_subject.present? && subject.present?
      errors.add(:subject, "should be blank if new subject selected")
    end
    if !new_category.present? && !new_subject.present? && !subject.present?
      errors.add(:subject, "should be selected or a new subject entered")
    end    
  end

  protected
    def check_published_flag
      if questions.size == 0
        self.published = false
        self.save!
      end
    end

end
