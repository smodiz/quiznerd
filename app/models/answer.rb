#:nodoc:
class Answer < ActiveRecord::Base
  belongs_to :question
  validates :content, presence: true
  validates :correct, inclusion: { in: [true, false] }
  default_scope -> { order('id') }
end
