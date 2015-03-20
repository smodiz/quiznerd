class ApiTokensController < ApplicationController

  before_action :authenticate_user!

  def create
    current_user.authentication_token = ''
    current_user.save
    respond_to do |format|
      format.js 
    end
  end
end