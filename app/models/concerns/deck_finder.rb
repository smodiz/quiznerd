module DeckFinder
  extend ActiveSupport::Concern

  included do
    include PgSearch
    pg_search_scope :search, against: [:name, :description, :status],
      using: { tsearch: { dictionary: "english" } }

    scope :published, -> { where(status: "Public") }
    scope :authored_by, ->(user){ where(user: user) }
    scope :ordered, -> { order("updated_at DESC") }  
    
    self.per_page = 10
  end

  module ClassMethods

    def search_by(query)
      do_search(query, "").published
    end

    def do_search(query, tag)
      if query.present?
        search(query)
      elsif tag.present?
        tagged_with(tag)
      else
        all
      end
    end

    def self.tagged_with(name)
      tag = Tag.where(name: name).first
      if tag.present?
        tag.decks 
      else
        []
      end
    end

    def search_owned_by(user,query,tag)
      do_search(query, tag).authored_by(user).includes(:tags).ordered
    end

    def new_for_user(user)
      user.decks.build
    end
  end
end