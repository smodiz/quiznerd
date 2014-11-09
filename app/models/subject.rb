class Subject < ActiveRecord::Base
  belongs_to :category
  has_many :quizzes
  default_scope -> { order(:name) }
end
