class StaticPagesController < ApplicationController
  
  LIMIT = 5

  def home
    if signed_in?
      @dash = Dashboard.new(current_user, LIMIT)
    end
  end

  def about
    @page = Page.find_by(name: "about")
  end

  def contact

  end

end
