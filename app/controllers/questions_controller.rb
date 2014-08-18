class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]

  def show
  end

  def new
    @question = Question.new_with_answers(params[:quiz_id])
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    if @question.save
       redirect_to quiz_path(@question.quiz_id), 
          notice: 'Question was successfully created.' 
    else
       render :new 
    end
  end

  def update
    if @question.update(question_params)
      redirect_to  @question.quiz, notice: 'Question was successfully updated.' 
    else
      render :edit 
    end
  end

  def destroy
    @quiz_id = @question.quiz_id
    @question.destroy
    redirect_to quiz_path(@quiz_id), notice: 'Question was successfully destroyed.' 
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:question_type, :content, :remarks, 
        :quiz_id, answers_attributes: [:id, :content, :correct, :_destroy])
    end
    
    def correct_user
      authorized = @question.quiz.author == current_user
      redirect_to root_url, notice: 'Unauthorized.' unless authorized
    end
end