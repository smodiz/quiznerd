class DeckEventsController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_user, only: :destroy

  def index
    @deck_events = DeckEvent.for_user(current_user).paginate(page: params[:page])
  end

  def new
    build_for_new
  end

  def create
    build
    save
  end

  def destroy
    load
    @deck_event.destroy
    redirect_to deck_events_path, notice: "Flash Card Event successfully destroyed!"
  end

  def clear
    current_user.deck_events.delete_all
    redirect_to deck_events_path, notice: "History successfully cleared!"
  end

  private

  def build_for_new
    params[:num_cards] = nil if params[:num_cards].present? && params[:num_cards].to_i <= 0 
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

  def load
    @deck_event ||= current_user.deck_events.find(params[:id])
  end

  def build
    @deck_event = DeckEvent.new(user: current_user)
    @deck_event.attributes = deck_event_params
  end

  def save
    @deck_event.save
    redirect_to deck_events_path, notice: "Your flash card study session was saved!"
  end

  def deck_event_params
    params.require(:deck_event).permit(:deck_id, :total_cards, :total_correct, :missed_cards_list)
  end

  def authorize_user
    @deck_event = current_user.deck_events.find_by(id: params[:id])
    redirect_to root_url, notice: 'You cannot modify that deck event.' if @deck_event.nil?
  end

end