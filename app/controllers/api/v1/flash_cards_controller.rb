module Api::V1 
  class FlashCardsController < ApplicationController

    def show 
      flash_card = FlashCard.find_by(id: params[:id])
      if flash_card
        render json: flash_card, status: 200
      else
        render nothing: true, status: 404
      end
    end  

  end
end