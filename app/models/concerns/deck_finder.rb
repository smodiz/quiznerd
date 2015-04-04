module DeckFinder
  extend ActiveSupport::Concern

  included do
    include PgSearch
    pg_search_scope :search,
                    against: [:name, :description, :status],
                    using: { tsearch: { dictionary: 'english' } }

    scope :published, -> { where(status: 'Public') }
    scope :authored_by, ->(user) { where(user: user) }
    default_scope -> { order('updated_at DESC') }

    self.per_page = 20
  end

  module ClassMethods
    def search_by(query)
      do_search(query, '').published
    end

    def new_for_user(user)
      user.decks.build
    end

    def decks_cache_key(user)
      ['decks_for_user', user]
    end

    def cached_for_user(user)
      Rails.cache.fetch(decks_cache_key(user), expires_in: 15.minutes) do
        authored_by(user).to_a
      end
    end
  end
end
