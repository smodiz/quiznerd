class FlashCardSerializer < ActiveModel::Serializer
  attributes :id, :front, :back, :sequence, :difficulty
end
