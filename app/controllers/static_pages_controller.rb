class StaticPagesController < ApplicationController
  LIMIT = 5

  def home
    @dash = Dashboard.new(current_user, LIMIT) if signed_in?
  end

  def about
    @page = Page.find_by(name: 'about')
  end

  def contact
  end
end
