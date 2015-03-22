class DeckSerializer < ActiveModel::Serializer
  attributes  :id, 
              :name, 
              :description, 
              :status, 
              :flash_cards_count
    
  has_many :flash_cards
end
