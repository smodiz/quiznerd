class Dashboard
  attr_reader :user, :quizzes, :quiz_events, :limit
  attr_reader :quizzes_count, :events_count
  attr_reader :cheatsheets, :decks
  attr_reader :cheatsheets_count, :decks_count

  def initialize(user, limit)
    @user = user
    @limit = limit
    set_counts
    load
  end

  def remaining_quizzes_count
    quizzes_count - quizzes.size
  end

  def remaining_events_count
    events_count - quiz_events.size
  end

  def remaining_cheatsheets_count
    cheatsheets_count - cheatsheets.size
  end

  def remaining_decks_count
    decks_count - decks.size
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
    @quizzes_count = user_quizzes.size
    @quizzes = user_quizzes.slice(0, limit)
  end

  def load_quiz_events
    user_events = QuizEvent.cached_for_user(user)
    @events_count = user_events.size
    @quiz_events = user_events.slice(0, limit)
  end

  def load_cheatsheets
    user_cheatsheets = Cheatsheet.cached_for_user(user)
    @cheatsheets_count = user_cheatsheets.size
    @cheatsheets = user_cheatsheets.slice(0, limit)
  end

  def load_flash_card_decks
    user_decks = Deck.cached_for_user(user)
    @decks_count = user_decks.size
    @decks = user_decks.slice(0, limit)
  end

  def set_counts
    @quizzes_count = 0
    @events_count = 0
    @cheatsheets_count = 0
    @decks_count = 0
  end
end
