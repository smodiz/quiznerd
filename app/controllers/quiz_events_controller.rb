class QuizEventsController < ApplicationController

  before_action :set_quiz_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  def index
    @quiz_events = QuizEvent.search_quizzes_taken(
      params[:search], current_user).paginate(page: params[:page])   
    @count = QuizEvent.count
  end

  def show
  end

  def new
    @quiz = Quiz.find(params[:quiz_id])
    @quiz_event = current_user.quiz_events.build(quiz: @quiz)
  end

  def edit
  end

  def create
    @quiz = Quiz.find(params[:quiz_id])
    @quiz_event = current_user.quiz_events.build(quiz: @quiz)
    if @quiz_event.save
      @quiz_taking_form = QuizTakingForm.new(quiz_event: @quiz_event, 
        view_context: view_context)
      render 'edit'
    else
      render 'new'
    end
  end

  def update
    @quiz_taking_form ||= QuizTakingForm.new(quiz_event: @quiz_event, 
      view_context: view_context)
    @quiz_taking_form.submit(quiz_event_params)
    render 'edit'
  end

  def destroy
    @quiz_event.destroy
    redirect_to (return_to_index? ? quiz_events_path : root_path), 
      notice: "Quiz event was successfully destroyed."
  end

  def clear
    current_user.quiz_events.delete_all
    redirect_to quiz_events_path, notice: "History successfully cleared!"
  end

  private

    def set_quiz_event
      @quiz_event ||= current_user.quiz_events.find(params[:id])
    end
   
    def return_to_index?
      params[:return_to].present? && params[:return_to] == "index"
    end

    # If radio button is the selector, we get a single string, if 
    # check boxes are the selectors, we get an array of strings. 
    # We want an array of integers all the time.
    def convert_answer_ids
      ids = params[:quiz_event][:answer_ids] if params[:quiz_event]
      if ids 
        params[:quiz_event][:answer_ids] = 
          ids.split.flatten.reject(&:blank?).map(&:to_i)
      end
    end

    # Note that answer_ids can be a single value (radio button) or multiple 
    # values (check boxes), thus it appears in this list both ways and we have
    # to convert it. 
    def quiz_event_params
      convert_answer_ids
      params.require(:quiz_event).permit(:id, :quiz_id, :question_id, 
        { :answer_ids => [] }, :answer_ids)
    end

end