class CheatsheetsFacade
  attr_reader :cheatsheets, :tag_names, :count

  def initialize(user, search, tag, page)
    @user = user
    @search = search
    @tag = tag
    @page =  page
    load
  end

  private

  def load
    @cheatsheets =
      Cheatsheet.search_owned_by(@user, @search, @tag).
        paginate(page: @page)
    @tag_names = Cheatsheet.tags_for(@user)
    @count = Cheatsheet.count
  end
end
