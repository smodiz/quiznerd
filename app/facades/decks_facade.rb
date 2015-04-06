#:nodoc:
class DecksFacade
  attr_reader :decks, :tag_names, :count

  def initialize(user, search, tag, page)
    @user = user
    @search = search
    @tag = tag
    @page =  page
    load
  end

  private

  def load
    @decks =
      Deck.search_owned_by(@user, @search, @tag).paginate(page: @page)
    @tag_names = Deck.tags_for(@user)
    @count = Deck.count
  end
end
