class StaticPagesController < ApplicationController
  
  LIMIT = 10

  def home
    if signed_in?
      get_quizzes
      get_quiz_events
    end
  end

  def get_quizzes
    @quizzes = current_user.quizzes.limit(LIMIT)
    @remaining_quizzes = @quizzes.size == LIMIT ? current_user.quizzes.size - LIMIT : 0
  end

  def get_quiz_events
    # not implemented yet
    @quiz_events = []
    @remaining_events = 0
  end

  def about
  end

  def contact
  end
end
