class CheatsheetsController < ApplicationController
  before_action :authenticate_user!

  def index 
    load_cheatsheets
  end

  def show 
    load_cheatsheet
  end

  def new 
    build_cheatsheet
  end

  def create
    build_cheatsheet
    save_cheatsheet or render 'new'
  end

  def edit 
    load_cheatsheet
    build_cheatsheet
  end

  def update
    load_cheatsheet
    build_cheatsheet
    save_cheatsheet or render 'edit'
  end

  def destroy
    load_cheatsheet
    @cheatsheet.destroy 
    redirect_to cheatsheets_path, success: "Cheatsheet was deleted." 
  end

  private

  def load_cheatsheets
    @facade = CheatsheetsFacade.new(
      current_user, 
      params[:search], 
      params[:tag], 
      params[:page]
    )
  end

  def load_cheatsheet
    @cheatsheet ||= cheatsheets_scope.where(id: params[:id]).first
    if @cheatsheet.nil?
      redirect_to root_url, error: "You can't modify a cheatsheet you don't own."
    end
  end

  def build_cheatsheet
    @cheatsheet ||= cheatsheets_scope.build 
    @cheatsheet.attributes = cheatsheet_params
  end

  def save_cheatsheet
    if @cheatsheet.save
      redirect_to @cheatsheet, success: "Cheatsheet was successfully saved." 
    end
  end

  def cheatsheet_params
    cs_params = params[:cheatsheet]
    if cs_params.present?
      cs_params.permit(:title, :content, :status_id, :tag_list, :page)
    else
      {}
    end
  end

  def cheatsheets_scope 
    current_user.cheatsheets
  end 

end