module Api::V1
  #:nodoc:
  class FlashCardsController < ApplicationController
    include FlashCardsCommon

    before_action :authenticate_user!

    def show
      flash_card = FlashCard.find_by(id: params[:id])
      if flash_card
        render json: flash_card, status: 200
      else
        render nothing: true, status: 404
      end
    end

    def create
      build
      if @flash_card.save
        render json: @flash_card,
               status: 201,
               location: [:api, :v1, @flash_card]
      else
        render json: @flash_card.errors.full_messages, status: 422
      end
    end
  end
end
