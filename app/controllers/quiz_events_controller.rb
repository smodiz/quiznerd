class QuizEventsController < ApplicationController

  before_action :set_quiz_event, only: [:show, :edit, :update, :destroy]
  
  def index
    @quiz_events = QuizEvent.search_quizzes_taken(params[:search], current_user).
        paginate(page: params[:page])   
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
      render 'edit'
    else
      render 'new'
    end
  end

  def update
    @quiz_event.update(quiz_event_params)
    if @quiz_event.status == QuizEvent::COMPLETED_STATUS
      render :show 
    else
      render :edit
    end
  end

  def destroy
    @quiz_event.destroy
    redirect_to root_path, notice: 'Quiz event was successfully destroyed.' 
  end

  private

    def set_quiz_event
      @quiz_event = current_user.quiz_events.find(params[:id])
    end
   
    # answer_ids is a virtual attribute on QuizEvent. Rails assigns it  
    # as a string (when only one is submitted via radio button) or string 
    # array (when multiple submitted, via checkboxes). However, what we 
    # want is an integer array.
    def convert_answer_ids
      answer_ids = params[:quiz_event][:answer_ids]
      return unless answer_ids
      converted_ids = []
      if answer_ids.class == String 
       converted_ids << answer_ids.to_i
     elsif answer_ids.class == Array
        answer_ids.each do |s|
          converted_ids << s.to_i unless s.blank?
        end
      end
      params[:quiz_event][:answer_ids] = converted_ids.sort
    end
   
    # Note that answer_ids can be a single value (radio button) or multiple values 
    # (check boxes), thus it appears in this list both ways
    def quiz_event_params
      convert_answer_ids
      params.require(:quiz_event).permit(:id, :quiz_id, :question_id, { :answer_ids => [] }, 
        :answer_ids, :suspend_button)
    end

end
