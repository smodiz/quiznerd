class FlashCard < ActiveRecord::Base
  belongs_to :deck, counter_cache: true

  DIFFICULTIES =  {   "1" => "Beginner",
                      "2" => "Intermediate",
                      "3" => "Advanced"  
                  }
  validates :sequence,    presence: true, uniqueness: { scope: :deck_id }
  validates :front,       presence: true
  validates :back,        presence: true
  validates :deck_id,     presence: true
  validates :difficulty,  inclusion: { in: DIFFICULTIES.keys }

end
