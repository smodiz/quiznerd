class FlashCardsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    load
    @flash_card.destroy
    respond_to do |format|
      format.html do
        redirect_to deck_path(@flash_card.deck), success: "Flash Card destroyed."
      end
      format.js
    end
  end

  def new
    @flash_card = FlashCard.new(deck_id: params[:deck_id])
  end

  def edit
    load
  end

  def update
    load
    @flash_card.attributes = flash_card_params
    @flash_card.save
    respond_to do |format|
      format.html { redirect_to @flash_card.deck }
      format.js
    end
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
    params.require(:flash_card).permit(
      :sequence, :front, :back, :difficulty, :deck_id)
  end
end
