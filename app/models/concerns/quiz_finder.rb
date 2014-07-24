module QuizFinder
  extend ActiveSupport::Concern

  included do 
    include PgSearch
    pg_search_scope :search, against: [:name, :description],
      using: {tsearch: {dictionary: "english" }},
      associated_against: {category: :name, subject: :name },
      :order_within_rank => "pg_search_rank"  #see comment below

      #order_within_rank by pg_search_rank means it orders by it twice,
      #which is harmless. If you don't specify a secondary sort, it
      #defaults to id, which was then making the sort I add on to the 
      #end at runtime via sortable headers useless

    scope :published,   -> { where(published: true) }
    scope :authored_by, -> (user) { where(author: user) }

    self.per_page = 10
  end

  module ClassMethods 

    def search_quiz_to_take(query)
      do_search(query).published
    end

    def search_owned_by(user,query)
      do_search(query).authored_by(user).includes(:category, :subject, :author, :questions)
    end

    def do_search(query)
      if query.present?
        search(query)  # see pg_search_scope
      else
        all
      end
    end

  end
end
