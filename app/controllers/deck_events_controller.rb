class DeckEventsController < ApplicationController

  before_action :authenticate_user!

  def index

  end

  def new
    load
  end

  def create
    deck_event = DeckEvent.new(user: current_user)
    deck_event.attributes = deck_event_params
    deck_event.save
    redirect_to deck_events_path, notice: "Your flash card study session was saved!"
  end

  private

  def load
    params[:num_cards] = nil if params[:num_cards].to_i <= 0 
    options = {
      order: (params[:order].present? ? params[:order].to_sym : nil),
      num_cards: params[:num_cards],
      difficulty: params[:difficulty],
      missed_filter: (params[:missed_filter].present? ? params[:missed_filter].to_sym : nil)
    }
    @deck_event = DeckEvent.new_with_options(
      deck_id: params[:deck_id], 
      user: current_user, 
      options: options
    )
  end

  def deck_event_params
    params.require(:deck_event).permit(:deck_id, :total_cards, :total_correct, :missed_cards_list)
  end


end