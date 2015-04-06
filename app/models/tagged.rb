# This module contains methods that are shared among all models
# that can be tagged, e.g. Deck, Cheatsheet, etc.
module Tagged
  extend ActiveSupport::Concern

  included do
    def tag_list=(tags)
      self.tags = tags.split(',').each.map do |name|
        Tag.where(name: name.strip).first_or_create!
      end
    end

    def tag_list
      tags.map(&:name).sort.join(', ')
    end
  end

  #:nodoc:
  module ClassMethods
    def search_owned_by(user, query, tag)
      do_search(query, tag).authored_by(user).includes(:tags)
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

    def tagged_with(name)
      tag = Tag.where(name: name).first
      if tag.present?
        tag.send(self.name.downcase.pluralize)
      else
        []
      end
    end

    def tags_for(user)
      relation = name.downcase.pluralize.to_sym
      Tag.includes(relation).where(relation => { user_id: user.id }).map(&:name)
    end
  end
end
