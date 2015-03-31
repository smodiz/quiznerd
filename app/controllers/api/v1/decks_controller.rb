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
        deck = Deck.new_for_user(current_user)
        deck.attributes = deck_params
        if deck.save
          render json: deck, status: 201, location: [:api, :v1, deck]
        else
          render json: deck.errors.full_messages, status: 422
        end
      end

      def update
        deck = current_user.decks.find_by(id: params[:id])
        if deck.nil?
          render nothing: true, status: 404
          return
        end
        deck.attributes = deck_params unless deck_params.blank?
        if deck.save
          render json: deck, status: 200
        else
          render json: deck.errors.full_messages, status: 422
        end
      end

      def destroy
        deck = current_user.decks.find_by(id: params[:id])
        if deck 
          deck.destroy!
          render nothing: true, status: 204
        else
          render nothing: true, status: 404
        end
      end

      private 

      def deck_params
        params.require(:deck).permit(:name, :description, :status, :tag_list, :page)
      end
    end
  end
end
