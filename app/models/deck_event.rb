=begin

A DeckEvent represents the results of a user playing through the flash cards
on a Deck. The only things recorded are which deck and user this
event belongs to, the total number of cards (after the user has specified any
filters to apply) and the user-reported number of correct answers.

=end
class DeckEvent < ActiveRecord::Base
  belongs_to :user 
  belongs_to :deck

  attr_writer :flash_card_set
  delegate :name, to: :deck
  delegate :id, to: :deck, prefix: true
  validates :total_cards, presence: true
  validates :total_correct, presence: true

  SORT_ORDER_OPTIONS =  {   in_order: "In order",
                            random:   "Random"
                        }

  MISSED_CARDS_OPTIONS = {  last_missed: "Last missed",
                            ever_missed: "Ever missed"
                          }

  def self.new_with_options(deck_id:, user:, options: {})
    deck = Deck.find(deck_id)
    deck_event = DeckEvent.new(deck: deck, user: user)
    if options.present?
      builder = FlashCardSetBuilder.new(deck, options)
      deck_event.flash_card_set = builder.generate_flash_cards
    end
    deck_event.total_cards = deck_event.count
    deck_event.total_correct = 0
    deck_event
  end

  def flash_card_set
    @flash_card_set || self.deck.flash_cards
  end

  def no_cards?
    flash_card_set.empty?
  end

  def full_count
    self.deck.flash_cards_count
  end

  def count
    @count ||= flash_card_set.size
  end

end
