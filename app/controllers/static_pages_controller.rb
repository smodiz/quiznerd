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
      user_quizzes = Quiz.cached_for_user(current_user)
      @quizzes = user_quizzes.slice(0, LIMIT)
      @num_remaining_quizzes = user_quizzes.size - @quizzes.size
    end

    def get_quiz_events
      user_events = QuizEvent.cached_for_user(current_user)
      @quiz_events = user_events.slice(0, LIMIT)
      @num_remaining_events = user_events.size - @quiz_events.size
    end
end
