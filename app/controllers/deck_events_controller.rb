#:nodoc:
class DeckEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, only: :destroy

  def index
    @deck_events = DeckEvent.for_user(current_user)
                   .paginate(page: params[:page])
  end

  def new
    build_new
  end

  def create
    build
    save
  end

  def destroy
    load
    @deck_event.destroy
    redirect_to deck_events_path, success: 'Flash Card Event destroyed!'
  end

  def clear
    current_user.deck_events.delete_all
    redirect_to deck_events_path, success: 'History successfully cleared!'
  end

  private

  def build_new
    @presenter = DeckEventPresenter.new(
      user: current_user,
      params: params,
      view_context: view_context
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
    redirect_to deck_events_path, success: 'Flash card study session was saved!'
  end

  def deck_event_params
    params.require(:deck_event).permit(
      :deck_id, :total_cards, :total_correct, :missed_cards_list)
  end

  def authorize_user
    @deck_event = current_user.deck_events.find_by(id: params[:id])
    if @deck_event.nil?
      redirect_to root_url, error: 'You can\'t modify that deck event.'
    end
  end
end
