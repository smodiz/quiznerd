=begin

This class generates the set of flash cards to play 
for a flash card event. When playing a flash card deck, 
flash cards can be filtered with these options:

- number of cards to see (e.g. 5, 10, 20), defaults to All. When
    filtering by number of cards, they won't necessarily be
    consecutive cards, but they will be in the right order 
    (e.g. if 5 cards are requested out of 20 total, you might get 
    cards number 2, 3, 6, 7, and 12)
- optionally filter by difficulty level of the cards (1=Beginner, 
    2=Intermediate, 3=advanced) 
- optionally filter on previously missed cards (either just the ones 
    that were missed last time or all that have ever been missed)
- optionally show them in a random order

=end

class FlashCardSetBuilder

  def initialize(deck, options={})
    @deck           = deck
    @num_cards      = options[:num_cards].present? ? options[:num_cards].to_i : nil
    @difficulty     = options[:difficulty]
    @order          = options[:order]
    @missed_filter  = options[:missed_filter]
    @flash_cards    = @deck.flash_cards.to_a
  end

  def generate_flash_cards
    filter_by_cards_missed if @missed_filter.present?
    filter_by_difficulty if @difficulty.present?
    reduce if @num_cards.present?
    shuffle if @order == :random
    @flash_cards
  end

  private

  def filter_by_cards_missed
    events_with_misses = DeckEvent.where(
      deck_id: @deck.id, 
      user_id: @deck.user_id
    ).where("missed_cards_list is not null")
    missed_card_ids = extract_missed_card_ids(events_with_misses)
    @flash_cards.select! { |fc| missed_card_ids.include?(fc.id) }
  end

  def extract_missed_card_ids(events_with_misses)
    if @missed_filter == :ever_missed
      extract_ever_missed(events_with_misses)
    elsif @missed_filter == :last_missed
      extract_last_missed(events_with_misses)
    end
  end

  def extract_ever_missed(events_with_misses)
    events_with_misses.each_with_object([]) do |fc, obj| 
      obj << fc.missed_cards_list.split(",").map(&:to_i)
    end.flatten.uniq
  end

  def extract_last_missed(events_with_misses)
    last_event = events_with_misses.order(updated_at: :desc).limit(1)
    if last_event.present?
      last_event.first.missed_cards_list.split(",").map(&:to_i)
    else
      []
    end
  end

  def filter_by_difficulty
    @flash_cards.reject! { |fc| fc.difficulty != @difficulty }
  end  

  def shuffle
    @flash_cards.shuffle!
  end

  def reduce
    @flash_cards = @flash_cards.sample(@num_cards).sort{ |a,b| a.sequence <=> b.sequence }
  end

end