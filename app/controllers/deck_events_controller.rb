class DeckEventsController < ApplicationController

  before_action :authenticate_user!

  def new
    load
  end


  private

  def load
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

end