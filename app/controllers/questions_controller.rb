class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]

  def show
  end

  def new
    @question = Question.new(quiz_id: params[:quiz_id])
    4.times { @question.answers.build }
  end

  def edit
  end

  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to quiz_path(@question.quiz_id), notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: quiz_path(@question.quiz_id) , status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to  @question.quiz, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @quiz_id = @question.quiz_id
    @question.destroy
    respond_to do |format|
      format.html { redirect_to quiz_path(@quiz_id), notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
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
