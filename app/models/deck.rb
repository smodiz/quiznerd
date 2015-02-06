class Deck < ActiveRecord::Base
  include DeckFinder
  
  belongs_to  :user
  has_many    :flash_cards

  STATUSES =  %w(Private Public)
  validates :name,                presence: true, length: { maximum: 45 }
  validates :description,         presence: true
  validates :user_id,             presence: true
  validates :flash_cards_count,   presence: true
  validates :status,              inclusion: { in: STATUSES }

 

end
