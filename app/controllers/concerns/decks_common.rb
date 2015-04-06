# These are methods that are mixed in with both the
# DecksController and the api version of the decks
# controller.
module DecksCommon
  def deck_params
    return {} unless params[:deck]
    params.require(:deck).permit(:name,
                                 :description,
                                 :status,
                                 :tag_list,
                                 :page)
  end

  def load_deck(eager_load: false)
    if eager_load
      @deck ||= Deck.with_flash_cards(params[:id])
    else
      @deck ||= Deck.find_by(id: params[:id])
    end
  end

  def build_deck
    @deck ||= Deck.new_for_user(current_user)
    @deck.attributes = deck_params unless deck_params.blank?
  end

  def deck_for(user:, id:)
    user.decks.find_by(id: id)
  end
end
