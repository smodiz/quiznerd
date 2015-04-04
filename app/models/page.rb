class Page < ActiveRecord::Base
  validates :name, uniqueness: true
  validates :content, presence: true
  validates :show, inclusion: { in: [true, false] }
end
