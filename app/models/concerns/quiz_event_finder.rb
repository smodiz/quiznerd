module QuizEventFinder
  extend ActiveSupport::Concern

  included do 
    include PgSearch
    pg_search_scope :search_events, against: [ :status ],
      using: {tsearch: {dictionary: "english" }},
      associated_against: { quiz: :name, subject: :name, category: :name }

    self.per_page = 10
    scope :taken_by, -> (user) { where(user: user) }
  end

  module ClassMethods 

    def search_quizzes_taken(query,user)
      do_search(query).taken_by(user).includes(:quiz)
    end

   def do_search(query)
      if query.present?
        search_events(query)
      else
        all
      end
    end
  end
end
