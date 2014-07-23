class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]

  helper_method :sort_column, :sort_direction

  def index
    @quizzes = Quiz.search_owned_by(current_user, params[:search]).
        order(sort_clause).paginate(page: params[:page]) 
  end

  def show
  end

  def new
    @quiz = Quiz.new
  end

  def edit
  end

  def create
    # temporary workaround
    # set published to false on create. Tried to use various callbacks on the 
    # # model to do this and it did not work. Come back and figure out why later.  
    @quiz = current_user.quizzes.build(quiz_params.merge(published: false))

    respond_to do |format|
      if @quiz.save
        format.html { redirect_to @quiz, notice: 'Quiz was successfully created.' }
        format.json { render :show, status: :created, location: @quiz }
      else
        format.html { render :new }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to @quiz, notice: 'Quiz was successfully updated.' }
        format.json { render :show, status: :ok, location: @quiz }
      else
        format.html { render :edit }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @quiz.destroy
    respond_to do |format|
      format.html { redirect_to quizzes_url, notice: 'Quiz was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_publish
    @quiz = Quiz.find(params[:quiz_id])
    @quiz.toggle_publish
    @quiz.save
    action = @quiz.published ? "published" : "unpublished" 
    respond_to do |format|
      format.html { redirect_to @quiz, notice: "Quiz was #{action}" }
      format.json { head :no_content }
    end
  end

  private

    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    def quiz_params
      params.require(:quiz).permit(:name, :description, :published, :category_id, :subject_id)
    end

    def correct_user
      @quiz = current_user.quizzes.find_by(id: params[:id])
      redirect_to root_url, notice: 'You cannot modify that quiz.' if @quiz.nil?
    end

    def sort_column
      Quiz.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sort_clause
      "#{sort_column} #{sort_direction}"
    end
end
