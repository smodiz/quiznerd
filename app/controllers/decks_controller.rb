class DecksController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, only: [:edit, :update, :destroy]
  before_action :build_deck, only: [:new, :create, :update]
  
  def index
    load_decks
  end

  def show
    load_deck(eager_load: true)
  end

  def new
  end

  def edit
  end

  def create
    save_deck or render :new
  end

  def update 
    save_deck or render :new
  end

  def destroy
    load_deck
    @deck.destroy
    redirect_to decks_path, notice: 'Deck was successfully destroyed.'
  end

  private

  def load_decks
    @decks = Deck.search_owned_by(current_user,params[:search],params[:tag]).
      paginate(page: params[:page])
    @tag_names = Deck.tags_for(current_user)
  end

  def load_deck(eager_load: false)
    if eager_load
      @deck ||= Deck.with_flash_cards(params[:id])
    else
      @deck ||= Deck.find(params[:id])
    end
  end

  def build_deck
    @deck ||= Deck.new_for_user(current_user)
    @deck.attributes = deck_params unless deck_params.blank?
  end

  def save_deck
    if @deck.save
      redirect_to @deck, notice: 'Deck was successfully saved.'
    end
  end

  def deck_params
    return {} unless params[:deck]
    params.require(:deck).permit(:name, :description, :status, :tag_list, :page)
  end

  def authorize_user
    @deck = current_user.decks.find_by(id: params[:id])
    redirect_to root_url, notice: "You cannot modify that Flash Deck." if @deck.nil?
  end

end
