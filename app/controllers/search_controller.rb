class SearchController < ApplicationController
  def new
  end

  def create
    # temporary, just to get results on page in order to implement "Take Quiz" first
    @quizzes = Quiz.search(params[:search])
    respond_to do |format|
      format.html { render 'show' }
    end
  end

  def show
  end
end
