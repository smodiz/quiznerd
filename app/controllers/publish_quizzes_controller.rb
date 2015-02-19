class PublishQuizzesController < ApplicationController
  
  before_action :authenticate_user!

  def create
    @quiz = Quiz.find(params[:quiz_id])
    @quiz.toggle_publish
    @quiz.save
    action = @quiz.published ? "published" : "unpublished" 
    redirect_to @quiz, notice: "Quiz was #{action}" 
  end

end