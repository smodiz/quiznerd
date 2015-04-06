#:nodoc:
class Category < ActiveRecord::Base
  has_many :subjects, dependent: :destroy
  has_many :quizzes
  default_scope -> { order(:name) }
end
