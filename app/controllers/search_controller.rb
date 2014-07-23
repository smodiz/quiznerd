class SearchController < ApplicationController
  
  def index
    @quizzes = Quiz.search_quiz_to_take(params[:search]).paginate(page: params[:page])
  end

end
