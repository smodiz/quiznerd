class FlashCard < ActiveRecord::Base
  belongs_to :deck, counter_cache: true

  DIFFICULTIES =  {   "1" => "Beginner",
                      "2" => "Intermediate",
                      "3" => "Advanced"  
                  }
  validates :sequence,    uniqueness: { scope: :deck_id }, if: :deck_id
  validates :front,       presence: true
  validates :back,        presence: true
  validates :difficulty,  inclusion: { in: DIFFICULTIES.keys }

  default_scope ->{ order(sequence: :asc) }

  before_validation :set_sequence

  def self.difficulty_description(key)
    DIFFICULTIES[key]
  end

  def set_sequence
    self.sequence = deck.next_sequence if self.sequence.blank?
  end

end