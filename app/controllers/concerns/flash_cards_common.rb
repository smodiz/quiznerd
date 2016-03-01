# These are methods that are mixed in with both the
# DecksController and the api version of the decks
# controller.
module FlashCardsCommon
  def build
    deck = Deck.find(flash_card_params[:deck_id])
    @flash_card = deck.flash_cards.build
    @flash_card.attributes = flash_card_params
  end

  def load
    @flash_card ||= FlashCard.find(params[:id])
  end

  def flash_card_params
    params.require(:flash_card).permit(
      :sequence, :front, :back, :difficulty, :deck_id)
  end
end