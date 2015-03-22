module Api
  class DecksController < ApplicationController

    def show
      deck = Deck.find(params[:id])
      render json: deck, status: 200
    end
  end
end
