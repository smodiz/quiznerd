class Cheatsheet < ActiveRecord::Base
  include PgSearch
  belongs_to :user
  belongs_to :status
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, :content, :status_id, presence: true
  validates :title, length: { maximum: 40 }

  attr_accessor :tag_list

  pg_search_scope :search, against: [:title, :content],
    using: {tsearch: {dictionary: "english" }},
    associated_against: { status: :name, tags: :name }
  self.per_page = 10
  
  scope :authored_by, -> (user) { where(user: user) }
  default_scope -> { order(:created_at) }

  def self.search_owned_by(user,query,tag)
    do_search(query,tag).authored_by(user).includes(:status, :tags)
  end

  def self.do_search(query,tag)
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
      tag.cheatsheets 
    else
      []
    end
  end

  def self.tags_for(user)
    Tag.includes(:cheatsheets).where(cheatsheets: { user_id: user.id }).map(&:name)
  end

  def tag_list
    self.tags.order(name: :asc).map(&:name).join(", ")
  end

  def tag_list=(tags)
    self.tags = tags.split(",").each.map do |name| 
      Tag.where(name: name.strip).first_or_create!
    end
  end

end
