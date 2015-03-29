module Api
  class DecksController < ApplicationController
    before_action :authenticate_user!

    def show
      deck = current_user.decks.find(params[:id])
      render json: deck, status: 200
    end

    def create
      deck = Deck.new(deck_params)
      if deck.save
        render json: deck, status: 201, location: [:api, deck]
      else
        render json: deck.errors.full_messages, status: 422
      end
    end

    private 

    def deck_params
      params.require(:deck).permit(:name, :description, :status, :tag_list, :user_id, :page)
    end
  end

end
