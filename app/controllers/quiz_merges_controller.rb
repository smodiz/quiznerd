class QuizMergesController < ApplicationController
  before_action :authenticate_user!

  def new
    @quiz_merge = QuizMerge.new
  end

  def create
    @quiz_merge = QuizMerge.new(merges_params.merge({ user: current_user }))
    if @quiz_merge.save
      redirect_to quiz_path(@quiz_merge.target_quiz), 
        success: "Merge completed successfully"
    else
      render :new 
    end
  end

  private

  def merges_params
    params.require(:quiz_merge).permit(:source_quiz_id, :target_quiz_id)
  end
end