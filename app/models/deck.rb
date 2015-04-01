class Deck < ActiveRecord::Base
  include DeckFinder
  include Tagged

  belongs_to  :user
  has_many    :flash_cards, dependent: :destroy
  has_many    :taggings, as: :taggable, dependent: :destroy
  has_many    :tags, through: :taggings
  has_many    :deck_events, dependent: :destroy

  after_commit      :invalidate_cache
  after_destroy     :invalidate_cache

  STATUSES =  %w(Private Public)
  validates :name,                presence: true, length: { maximum: 45 }
  validates :description,         presence: true
  validates :user_id,             presence: true
  validates :flash_cards_count,   presence: true
  validates :status,              presence: true, inclusion: { in: STATUSES }

  def self.with_flash_cards(id)
    Deck.includes(:flash_cards).find_by(id: id)
  end

  def next_sequence
    (flash_cards.map(&:sequence).max || 0) + 1
  end

  private 

   def invalidate_cache
    Rails.cache.delete(Deck.decks_cache_key(user))
  end

end
