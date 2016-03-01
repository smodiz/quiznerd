#:nodoc:
class DeckSerializer < ActiveModel::Serializer
  attributes :id,
             :user_id,
             :name,
             :description,
             :status,
             :flash_cards_count

  has_many :flash_cards
  has_many :tags
end
