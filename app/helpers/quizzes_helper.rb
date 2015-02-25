module QuizzesHelper

  def new_quiz_button
    link_to "<i class='#{Icon::NEW}'></i> New Quiz".html_safe, 
      new_quiz_path, class: 'btn btn-primary pull-right btn-sm' 
  end

  def publish_label
    @quiz.published ? "Unpublish" : "Publish"
  end

  def show_published_link?
    @quiz.published || (!@quiz.published && @quiz.can_publish?)
  end

end