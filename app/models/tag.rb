class Tag < ActiveRecord::Base
  has_many  :taggings, dependent: :destroy
  has_many  :cheatsheets, 
            through: :taggings, 
            source: :taggable, 
            source_type: 'Cheatsheet'

  validates :name, presence: true
end