class Quiz < ActiveRecord::Base
  belongs_to :category
  belongs_to :subject
  belongs_to :author, class_name: "User"
  has_many :questions, dependent: :destroy
  
  default_scope -> { order('created_at') }
  validates :name, :description, :author, :category, :subject, presence: true
  validates :published, inclusion: { in: [true, false] }
  
  # This didn't work
  # before_validation(on: :create) do
  #   self.published = false
  # end
  # Also tried the above with a before_create callback. Didn't work either. Argh!
 
  def self.search(search)
    if search
      Quiz.where("name like ?", "%#{search}%").where(published: true)
    else
      Quiz.all.where(published:true) 
    end
  end

  def question_number(number)
    questions[number]
  end

  def number_of_questions
    questions.size
  end

  def can_publish?
    number_of_questions >= 3
  end

  def toggle_publish
    if published
      self.toggle(:published)   # can unpublish at will
    elsif can_publish?  # but publishing requires validation
      self.toggle(:published)
    end
  end


end
