class QuizzesController < ApplicationController
  include SortableColumns


  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    load_quizzes
  end

  def show
    load_quiz(eager_load: true)
  end

  def new
    build_quiz
  end

  def edit
    load_quiz
  end

  def create
    build_quiz
    save_quiz or render :new 
  end

  def update
    build_quiz
    save_quiz or render :edit
  end

  def destroy
    load_quiz
    @quiz.destroy
    redirect_to quizzes_path, notice: 'Quiz was successfully destroyed.' 
  end

  def toggle_publish
    @quiz = Quiz.find(params[:quiz_id])
    @quiz.toggle_publish
    @quiz.save
    action = @quiz.published ? "published" : "unpublished" 
    redirect_to @quiz, notice: "Quiz was #{action}" 
  end

  private

  def load_quizzes
    @quizzes = Quiz.search_owned_by(current_user, params[:search]).
        reorder(sort_clause).paginate(page: params[:page]) 
  end

  def load_quiz(eager_load:false)
    if eager_load
      @quiz = Quiz.with_questions_and_answers(params[:id])
    else
      @quiz = Quiz.find(params[:id])
    end
  end

  def build_quiz
    @quiz ||= Quiz.new_for_user(current_user)
    @quiz.attributes = quiz_params unless quiz_params.blank?
  end

  def save_quiz
    if @quiz.save
      redirect_to @quiz, notice: 'Quiz was successfully saved.' 
    end
  end

  def quiz_params
    return {} unless params[:quiz]
    params.require(:quiz).permit(:name, :description, :published, 
      :category_id, :subject_id, :new_category, :new_subject)
  end

  def correct_user
    @quiz = current_user.quizzes.find_by(id: params[:id])
    redirect_to root_url, notice: 'You cannot modify that quiz.' if @quiz.nil?
  end
  
end