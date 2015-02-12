class StaticPagesController < ApplicationController
  
  LIMIT = 10

  def home
    if signed_in?
      @dash = Dashboard.new(current_user, LIMIT)
    end
  end

  def about
  end

  def contact
  end

end
