class StaticPagesController < ApplicationController
  
  LIMIT = 10

  def home
    if signed_in?
      get_quizzes
      get_quiz_events
    end
  end

  def about
  end

  def contact
  end

  private 

    def get_quizzes
      @quizzes = current_user.quizzes.ordered.limit(LIMIT)
      @num_remaining_quizzes = @quizzes.size == LIMIT ? current_user.quizzes.size - LIMIT : 0
    end

    def get_quiz_events
      @quiz_events = current_user.quiz_events.ordered.limit(LIMIT) 
      @num_remaining_events = @quiz_events.size == LIMIT ? current_user.quiz_events.size - LIMIT : 0
    end
end
