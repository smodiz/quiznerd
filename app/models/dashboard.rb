class Dashboard

  attr_reader :user, :quizzes, :quiz_events, :limit
  attr_reader :num_remaining_quizzes, :num_remaining_events

  def initialize(user, limit)
    @user = user
    @limit = limit
    get_quizzes
    get_quiz_events
  end

  private

  def get_quizzes
    user_quizzes = Quiz.cached_for_user(user)
    @quizzes = user_quizzes.slice(0, limit)
    @num_remaining_quizzes = user_quizzes.size - quizzes.size
  end

  def get_quiz_events
    user_events = QuizEvent.cached_for_user(user)
    @quiz_events = user_events.slice(0, limit)
    @num_remaining_events = user_events.size - quiz_events.size
  end

  

end