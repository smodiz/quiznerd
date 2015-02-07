class FlashCardsController < ApplicationController

  def destroy
    load
    @flash_card.destroy
    redirect_to deck_path(@flash_card.deck), notice: "Flash Card destroyed."
  end

  def new
    @flash_card = FlashCard.new(deck_id: params[:deck_id])
  end

  def create
    @flash_card = FlashCard.create!(flash_card_params)
    respond_to do |format|
      format.html { redirect_to @flash_card.deck }
      format.js
    end
  end


  private

  def load
    @flash_card ||= FlashCard.find(params[:id])
  end

  def flash_card_params
    params.require(:flash_card).permit(:sequence, :front, :back, :difficulty, :deck_id)
  end

end