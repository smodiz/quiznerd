class Quiz < ActiveRecord::Base
  belongs_to :category
  belongs_to :subject
  belongs_to :author, class_name: "User"
  validates :name, :description, :author, :category, :subject, presence: true
  validates :published, inclusion: { in: [true, false] }
end
