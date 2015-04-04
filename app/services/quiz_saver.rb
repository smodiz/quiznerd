# Since creating a Quiz involves collaboration between
# multiple models, this is a service object to
# handle the process of creating a Quiz, and creating
# the related Category and Subject, too, if needed.
class QuizSaver
  def initialize(quiz, new_category, new_subject)
    @quiz = quiz
    @new_category = new_category
    @new_subject = new_subject
  end

  def save
    create_category if @new_category.present?
    create_subject if @new_subject.present?
    @quiz.save
  end

  private

  def create_category
    @quiz.category_id = Category.find_or_create_by!(
      name: @new_category.strip.titleize).id
  end

  def create_subject
    @quiz.subject_id = Subject.find_or_create_by!(
      name: @new_subject.strip.titleize,
      category_id: @quiz.category_id).id
  end
end
