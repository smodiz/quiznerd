# A DeckEvent represents the results of a user playing through the flash cards
# on a Deck. The things persisted are: which deck and user this
# event belongs to, the total number of cards (after the user has specified any
# filters to apply), the user-reported number of correct answers, and which
# ones they missed.
class DeckEvent < ActiveRecord::Base
  include Gradeable

  belongs_to :user
  belongs_to :deck

  delegate :name, to: :deck
  delegate :id, to: :deck, prefix: true
  validates :total_cards, presence: true
  validates :total_correct, presence: true

  default_scope -> { order(created_at: :desc) }

  SORT_ORDER_OPTIONS =  {   in_order: 'In order',
                            random:   'Random'
                        }

  MISSED_CARDS_OPTIONS = {  last_missed: 'Last missed',
                            ever_missed: 'Ever missed'
                          }

  self.per_page = 20

  def self.new_for(deck_id:, user:)
    deck = Deck.find(deck_id)
    deck_event = DeckEvent.new(deck: deck, user: user)
    deck_event.total_cards = deck.flash_cards_count
    deck_event.total_correct = 0
    deck_event
  end

  def self.for_user(user)
    DeckEvent.where(user: user).includes(:deck)
  end

  def full_count
    deck.flash_cards_count
  end

  def total_answered
    total_cards
  end
end
