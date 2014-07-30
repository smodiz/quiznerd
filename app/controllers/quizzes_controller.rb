class QuizzesController < ApplicationController
  include SortableColumns

  before_action :set_quiz, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @quizzes = Quiz.search_owned_by(current_user, params[:search]).
        reorder(sort_clause).paginate(page: params[:page]) 
  end

  def show
  end

  def new
    @quiz = Quiz.new
  end

  def edit
  end

  def create
    @quiz = current_user.quizzes.build(quiz_params)
    if @quiz.save
      redirect_to @quiz, notice: 'Quiz was successfully created.' 
    else
      render :new 
    end
  end

  def update
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: 'Quiz was successfully updated.' 
    else
      render :edit 
    end
  end

  def destroy
    @quiz.destroy
    redirect_to quizzes_url, notice: 'Quiz was successfully destroyed.' 
  end

  def toggle_publish
    @quiz = Quiz.find(params[:quiz_id])
    @quiz.toggle_publish
    @quiz.save
    action = @quiz.published ? "published" : "unpublished" 
    redirect_to @quiz, notice: "Quiz was #{action}" 
  end

  private

    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    def quiz_params
      params.require(:quiz).permit(:name, :description, :published, 
        :category_id, :subject_id, :new_category, :new_subject)
    end

    def correct_user
      @quiz = current_user.quizzes.find_by(id: params[:id])
      redirect_to root_url, notice: 'You cannot modify that quiz.' if @quiz.nil?
    end

  
end