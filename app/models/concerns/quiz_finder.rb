#:nodoc:
module QuizFinder
  extend ActiveSupport::Concern

  included do
    include PgSearch
    pg_search_scope(
      :search,
      against: [:name, :description],
      using: { tsearch: { dictionary: 'english' } },
      associated_against: { category: :name, subject: :name })

    scope :published,   -> { where(published: true) }
    scope :authored_by, -> (user) { where(author: user) }
    scope :ordered,     -> { order('updated_at DESC') }

    self.per_page = 10
  end

  #:nodoc:
  module ClassMethods
    def search_quiz_to_take(query)
      do_search(query).published
    end

    def search_owned_by(user, query)
      do_search(query).authored_by(user).includes(:category, :subject, :author)
    end

    def do_search(query)
      if query.present?
        search(query)
      else
        all
      end
    end

    def new_for_user(user)
      user.quizzes.build
    end

    def with_questions_and_answers(id)
      Quiz.includes(:category, :subject, questions: [:answers]).find(id)
    end

    def quizzes_cache_key(user)
      ['quizzes_for_user', user]
    end

    def cached_for_user(user)
      Rails.cache.fetch(quizzes_cache_key(user), expires_in: 15.minutes) do
        authored_by(user).ordered.to_a
      end
    end
  end
end
