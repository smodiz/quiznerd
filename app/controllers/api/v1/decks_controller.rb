module Api
  module V1
    class DecksController < ApplicationController
      before_action :authenticate_user!

      def index
        decks = current_user.decks
        render json: decks, status: 200
      end

      def show
        deck = current_user.decks.find_by(id: params[:id])
        if deck
          render json: deck, status: 200
        else
          render nothing: true, status: 404
        end
      end

      def create
        deck = Deck.new(deck_params)
        if deck.save
          render json: deck, status: 201, location: [:api, :v1, deck]
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
end
