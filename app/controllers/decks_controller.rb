#:nodoc:
class DecksController < ApplicationController
  include DecksCommon

  before_action :authenticate_user!
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    load_decks
  end

  def show
    load_deck(eager_load: true)
  end

  def new
    build_deck
  end

  def edit
  end

  def create
    build_deck
    save_deck or render :new
  end

  def update
    build_deck
    save_deck or render :new
  end

  def destroy
    load_deck
    @deck.destroy
    redirect_to decks_path, success: 'Deck was successfully destroyed.'
  end

  private

  def load_decks
    @facade = DecksFacade.new(
      current_user,
      params[:search],
      params[:tag],
      params[:page]
    )
  end

  def save_deck
    if @deck.save
      redirect_to @deck, success: 'Deck was successfully saved.'
    end
  end

  def authorize_user
    @deck = deck_for(user: current_user, id: params[:id])
    if @deck.nil?
      redirect_to root_url, error: "You can't modify that Flash Deck."
    end
  end
end
