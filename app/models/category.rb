class Category < ActiveRecord::Base
  has_many :subjects, dependent: :destroy
  default_scope -> { order(:name) }
end
