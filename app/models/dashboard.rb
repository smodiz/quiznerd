class Dashboard

  attr_reader :user, :quizzes, :quiz_events, :limit
  attr_reader :num_remaining_quizzes, :num_remaining_events
  attr_reader :cheatsheets, :decks
  attr_reader :num_remaining_cheatsheets, :num_remaining_decks

  def initialize(user, limit)
    @user = user
    @limit = limit
    load
   
  end

  private

  def load
    load_quizzes
    load_quiz_events
    load_cheatsheets
    load_flash_card_decks
  end

  def load_quizzes
    user_quizzes = Quiz.cached_for_user(user)
    @quizzes = user_quizzes.slice(0, limit)
    @num_remaining_quizzes = user_quizzes.size - quizzes.size
  end

  def load_quiz_events
    user_events = QuizEvent.cached_for_user(user)
    @quiz_events = user_events.slice(0, limit)
    @num_remaining_events = user_events.size - quiz_events.size
  end

  def load_cheatsheets
    user_cheatsheets = Cheatsheet.cached_for_user(user)
    @cheatsheets = user_cheatsheets.slice(0, limit)
    @num_remaining_cheatsheets = user_cheatsheets.size - cheatsheets.size
  end

  def load_flash_card_decks
    user_decks = Deck.cached_for_user(user)
    @decks = user_decks.slice(0, limit)
    @num_remaining_decks = user_decks.size - decks.size
  end
end