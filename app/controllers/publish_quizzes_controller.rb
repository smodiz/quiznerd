class PublishQuizzesController < ApplicationController
  
  before_action :authenticate_user!, :authorize_user

  def create
    @quiz.toggle_publish
    @quiz.save
    action = @quiz.published ? "published" : "unpublished" 
    redirect_to @quiz, notice: "Quiz was #{action}" 
  end

  private

  def authorize_user
    @quiz = current_user.quizzes.find_by(id: params[:quiz_id])
    redirect_to root_url, notice: "You cannot publish that Quiz." if @quiz.nil?
  end

end