class Cheatsheet < ActiveRecord::Base
  include PgSearch
  include Tagged

  belongs_to :user
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, :content, presence: true
  validates :title, length: { maximum: 40 }

  pg_search_scope :search, against: [:title, :content],
    using: {tsearch: {dictionary: "english" }},
    associated_against: { tags: :name }
  self.per_page = 20
  
  scope :authored_by, -> (user) { where(user: user) }
  default_scope -> { order(created_at: :desc) }

  after_commit      :invalidate_cache
  after_destroy     :invalidate_cache

  def self.cached_for_user(user)
    Rails.cache.fetch(cheatsheets_cache_key(user), :expires_in => 15.minutes) do
      authored_by(user).to_a
    end
  end

  private 

  def self.cheatsheets_cache_key(user)
    ["cheatsheets_for_user", user]
  end

  def invalidate_cache
    Rails.cache.delete(Cheatsheet.cheatsheets_cache_key(user))
  end
end
