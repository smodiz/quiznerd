class Cheatsheet < ActiveRecord::Base
  include PgSearch
  include Tagged

  belongs_to :user
  belongs_to :status
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, :content, :status_id, presence: true
  validates :title, length: { maximum: 40 }

  pg_search_scope :search, against: [:title, :content],
    using: {tsearch: {dictionary: "english" }},
    associated_against: { status: :name, tags: :name }
  self.per_page = 20
  
  scope :authored_by, -> (user) { where(user: user) }
  default_scope -> { order(created_at: :desc) }

end
