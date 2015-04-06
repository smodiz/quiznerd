#:nodoc:
module Api::V1
  #:nodoc:
  class DecksController < ApplicationController
    include DecksCommon

    before_action :authenticate_user!
    before_action :authorize_user, only: [:destroy, :update]

    def index
      decks = current_user.decks
      render json: decks, status: 200
    end

    def show
      load_deck
      if @deck
        render json: @deck, status: 200
      else
        render nothing: true, status: 404
      end
    end

    def create
      build_deck
      if @deck.save
        render json: @deck, status: 201, location: [:api, :v1, @deck]
      else
        render json: @deck.errors.full_messages, status: 422
      end
    end

    def update
      build_deck
      if @deck.save
        render json: @deck, status: 200
      else
        render json: @deck.errors.full_messages, status: 422
      end
    end

    def destroy
      load_deck
      if @deck
        @deck.destroy!
        render nothing: true, status: 204
      else
        render nothing: true, status: 404
      end
    end

    def authorize_user
      @deck = deck_for(user: current_user, id: params[:id])
      if @deck.nil?
        render nothing: true, status: 404 and return false
      end
    end
  end
end
