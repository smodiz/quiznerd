#:nodoc:
class FlashCardSerializer < ActiveModel::Serializer
  attributes :id, :front, :back, :sequence, :difficulty, :deck_id
end
