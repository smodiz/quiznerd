class CopyQuestionsController < ApplicationController 
  before_action :authenticate_user!

  def create
    @question = QuestionCloner.clone(Question.find(params[:question_id]))
    render "questions/new"
  end

end