class FlashCard < ActiveRecord::Base
  belongs_to :deck, counter_cache: true

  DIFFICULTIES =  {   "1" => "Beginner",
                      "2" => "Intermediate",
                      "3" => "Advanced"  
                  }
  validates :sequence,    uniqueness: { scope: :deck_id }
  validates :front,       presence: true
  validates :back,        presence: true
  validates :deck_id,     presence: true
  validates :difficulty,  inclusion: { in: DIFFICULTIES.keys }

  default_scope ->{ order(sequence: :asc) }

  before_save :set_sequence

  def self.difficulty_description(key)
    DIFFICULTIES[key]
  end

  private

  def set_sequence
    if self.sequence.nil?
      self.sequence = (FlashCard.maximum("sequence").to_i + 1).to_s
    end
  end

end
