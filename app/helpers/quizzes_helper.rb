module QuizzesHelper

  def new_quiz_button(min_quizzes_size: 1)
    if @quizzes.size >= min_quizzes_size
      link_to '<i class="glyphicon glyphicon-plus glyphicon-white"></i> New Quiz'.html_safe, 
        new_quiz_path, class: 'btn btn-primary pull-right btn-sm' 
    end
  end

  def publish_label
    @quiz.published ? "Unpublish" : "Publish"
  end

  def show_published_link?
    @quiz.published || (!@quiz.published && @quiz.can_publish?)
  end

end