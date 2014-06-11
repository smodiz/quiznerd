class Quiz < ActiveRecord::Base
  belongs_to :category
  belongs_to :subject
  belongs_to :author, class_name: "User"
  has_many :questions
  
  validates :name, :description, :author, :category, :subject, presence: true
  validates :published, inclusion: { in: [true, false] }
  
  # This didn't work
  # before_validation(on: :create) do
  #   self.published = false
  # end

  # Also tried the above with a before_create callback. Didn't work either. Argh!
 

end
