class Deck < ActiveRecord::Base
  include DeckFinder

  belongs_to  :user
  has_many    :flash_cards
  has_many    :taggings, as: :taggable, dependent: :destroy
  has_many    :tags, through: :taggings


  STATUSES =  %w(Private Public)
  validates :name,                presence: true, length: { maximum: 45 }
  validates :description,         presence: true
  validates :user_id,             presence: true
  validates :flash_cards_count,   presence: true
  validates :status,              inclusion: { in: STATUSES }

  def self.with_flash_cards(id)
    Deck.includes(:flash_cards).find(id)
  end

 def self.tagged_with(name)
    tag = Tag.where(name: name).first
    if tag.present?
      tag.decks 
    else
      []
    end
  end

  def self.tags_for(user)
    Tag.includes(:decks).where(decks: { user_id: user.id }).map(&:name)
  end

  def tag_list
    self.tags.order(name: :asc).map(&:name).join(", ")
  end

  def tag_list=(tags)
    self.tags = tags.split(",").each.map do |name| 
      Tag.where(name: name.strip).first_or_create!
    end
  end

end
