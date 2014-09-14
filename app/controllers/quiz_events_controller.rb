class QuizEventsController < ApplicationController

  before_action :set_quiz_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  def index
    @quiz_events = QuizEvent.search_quizzes_taken(
      params[:search], current_user).paginate(page: params[:page])   
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
    @quiz_event = current_user.quiz_events.build(quiz_event_params)
    if @quiz_event.save
      @quiz_form = QuizTakingForm.new(quiz_event: @quiz_event, view_context: view_context)
      render 'edit'
    else
      render 'new'
    end
  end

  def update
    @quiz_form = QuizTakingForm.new(quiz_event: @quiz_event, view_context: view_context)
    @quiz_form.submit(quiz_event_params)
    render 'edit'
  end

  def destroy
    @quiz_event.destroy
    redirect_to (return_to_index? ? quiz_events_path : root_path), 
      notice: "Quiz event was successfully destroyed."
  end

  private

    def set_quiz_event
      @quiz_event = current_user.quiz_events.find(params[:id])
    end
   
    def return_to_index?
      params[:return_to].present? && params[:return_to] == "index"
    end

    # answer_ids is a virtual attribute on QuizEvent. Rails assigns it  
    # as a string (when only one is submitted via radio button) or string 
    # array (when multiple submitted, via checkboxes). However, what we 
    # want is an integer array, always.
    def convert_answer_ids
      answer_ids = params[:quiz_event][:answer_ids]
      return unless answer_ids
      converted_ids = convert_to_integers(answer_ids)
      params[:quiz_event][:answer_ids] = converted_ids.sort
    end
   
    def convert_to_integers(answer_ids)
      converted_ids = []
      if answer_ids.class == String 
       converted_ids << answer_ids.to_i
     elsif answer_ids.class == Array
        answer_ids.each do |s|
          converted_ids << s.to_i unless s.blank?
        end
      end
      converted_ids
    end

    # Note that answer_ids can be a single value (radio button) or multiple 
    # values (check boxes), thus it appears in this list both ways
    def quiz_event_params
      convert_answer_ids
      params.require(:quiz_event).permit(:id, :quiz_id, :question_id, 
        { :answer_ids => [] }, :answer_ids)
    end

end