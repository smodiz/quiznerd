# This is the model used for the content
# of static pages, namely the about page.
class Page < ActiveRecord::Base
  validates :name, uniqueness: true
  validates :content, presence: true
  validates :show, inclusion: { in: [true, false] }
end
