class QuizEventsController < ApplicationController
  before_action :set_quiz_event, only: [:show, :edit, :update, :destroy]
  

  # GET /quiz_events
  # GET /quiz_events.json
  def index
    @quiz_events = current_user.quiz_events
  end

  # GET /quiz_events/1
  # GET /quiz_events/1.json
  def show
  end


  # GET /quiz_events/new
  def new
    @quiz = Quiz.find(params[:quiz_id])
    @quiz_event = current_user.quiz_events.build(quiz: @quiz)
  end

  # GET /quiz_events/1/edit
  def edit
  end

  # POST /quiz_events
  # POST /quiz_events.json
  def create
    @quiz_event = current_user.quiz_events.build(quiz_event_params)
    if @quiz_event.save
      render 'edit'
    else
      render 'new'
    end
  end


  # PATCH/PUT /quiz_events/1
  def update
    
    # handle back-button shenanigans
    if question_repeated? 
      handle_repeat
      return
    end

    @quiz_event.update(quiz_event_params)
    if suspend? || @quiz_event.status == QuizEvent::COMPLETED_STATUS
      render :show 
    else
      render :edit
    end
  end

  # DELETE /quiz_events/1
  # DELETE /quiz_events/1.json
  def destroy
    @quiz_event.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Quiz event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # make sure user doesn't use back button to re-answer a question
    def question_repeated?
      @quiz_event.last_question_id && 
        quiz_event_params[:question_id].to_i <= @quiz_event.last_question_id 
    end

    def set_quiz_event
      @quiz_event = current_user.quiz_events.find(params[:id])
     
    end
   
    def suspend?
      params[:suspend_button]
    end

    def handle_repeat
      if @quiz_event.status == QuizEvent::IN_PROGRESS_STATUS
        @quiz_event.reset
        flash.now[:error] = "Can't answer the same question twice. Please answer the next question, shown below."
        render :edit
      elsif @quiz_event.status == QuizEvent::COMPLETED_STATUS
        flash.now[:error] = "Can't answer that question again. You've already completed this quiz."
        render :show
      end
    end


    # answer_ids is a virtual attribute that rails assigns to the variable as a string (when only 
    # one is submitted via radio button) or string array (when multiple submitted, via checkboxes).
    # However, what we want is an integer array. 
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
   
    # Never trust parameters from the scary internet, only allow the white list through.
    # Note that answer_ids can be a single value (radio button) or multiple values 
    # (check boxes), thus it appears in this list both ways
    def quiz_event_params
      convert_answer_ids
      params.require(:quiz_event).permit(:id, :quiz_id, :question_id, { :answer_ids => [] }, :answer_ids, :suspend_button)
    end


end
