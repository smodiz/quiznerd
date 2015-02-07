class FlashCardsController < ApplicationController

  def destroy
    load
    @flash_card.destroy
    redirect_to deck_path(@flash_card.deck), notice: "Flash Card destroyed."
  end

  private

  def load
    @flash_card ||= FlashCard.find(params[:id])
  end

end