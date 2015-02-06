module DeckFinder
  extend ActiveSupport::Concern

  included do
    include PgSearch
    pg_search_scope :search, against: [:name, :description],
      using: { tsearch: { dictionary: "english" } }

    scope :published, -> { where(status: "Public") }
    scope :owned_by, ->(user){ where(user: user) }
    scope :ordered, -> { order("updated_at DESC") }  
    
    self.per_page = 10
  end

  module ClassMethods

    def search_by(query)
      do_search(query).published
    end

    def do_search(query)
      if query.present?
        search(query)
      else
        all
      end
    end

    def search_owned_by(query,user)
      do_search(query).owned_by(user).ordered
    end
  end
end