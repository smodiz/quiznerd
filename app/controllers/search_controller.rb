class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @quizzes = Quiz.search_quiz_to_take(params[:search]).paginate(
      page: params[:page])
  end

end