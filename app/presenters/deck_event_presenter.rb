#  This presenter holds data/behavior related to the 
#  playing of flash card decks, which are called deck
#  events, for lack of a better name.
# 
# The user can filter the cards by a few different
# means, and then study (or "play") only those. The 
# filteres list is not persisted anywhere nor is it
# required after playing is completed, so that logic
# and data exists only here, not in the DeckEvent model.

class DeckEventPresenter < BasePresenter
  presents :deck_event

  attr_accessor :flash_card_set

  def initialize(user:, params: {}, view_context:)
    event = DeckEvent.new_for(deck_id: params[:deck_id], user: user)
    
    if params.present?
      builder = FlashCardSetBuilder.new(event.deck, build_options(params))
      self.flash_card_set = builder.generate_flash_cards
    else
      self.flash_card_set = event.deck.flash_cards.to_a
    end
    event.total_cards = flash_card_set.size
    super(event, view_context)
  end

  def no_cards?
    flash_card_set.empty?
  end

  def card_count
    flash_card_set.present? ? flash_card_set.size : 0
  end

  def thumbs_up_link(flash_card)
    id = "correct-answer-#{flash_card.id}"
    icon = '<i class="glyphicon glyphicon-thumbs-up glyphicon-white"></i>'
    h.link_to icon.html_safe, 
            '#', 
            class: 'btn btn-success btn-sm correct-flash-answer flash-answer',
              id: id
  end

  def thumbs_down_link(flash_card)
    id = "incorrect-answer-#{flash_card.id}"
    icon = '<i class="glyphicon glyphicon-thumbs-down glyphicon-white"></i>'
      h.link_to icon.html_safe, 
              '#', 
              class: 'btn btn-danger btn-sm incorrect-flash-answer flash-answer',
              id: id
  end

  def advance_flash_card_link(flash_card)
    id = "advance-#{flash_card.id}"
    icon = '<i class="glyphicon glyphicon-arrow-right glyphicon-white"></i>'
    h.link_to icon.html_safe, 
            '#', 
            class: 'btn btn-primary btn-sm flash-advance',
              id: id
  end

  def self.clear_history_link(context)
   context.link_to \
    '<i class="glyphicon glyphicon-plus glyphicon-white"></i> Reset History'.html_safe,
      context.clear_deck_events_history_path, 
      method: :delete, 
      data: { confirm: "Are you sure? This will delete all of your study history." },
      class: 'btn btn-danger pull-right btn-sm' 
  end

  private 

  def build_options(params)
   {
      order: (params[:order].present? ? params[:order].to_sym : nil),
      num_cards: params[:num_cards],
      difficulty: params[:difficulty],
      missed_filter: (params[:missed_filter].present? ? params[:missed_filter].to_sym : nil)
    }
  end

end