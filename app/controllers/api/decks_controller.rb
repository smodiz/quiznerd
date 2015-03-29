module Api
  class DecksController < ApplicationController
    before_action :authenticate_user!

    def show
      deck = Deck.find(params[:id])
      render json: deck, status: 200
    end

 
  end

end
