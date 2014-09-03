class CategorySubjectCreator 

  def initialize(quiz)
    @quiz = quiz
  end

  def create
    if @quiz.valid?
      create_category
      create_subject
    end
  end

  def create_category
    if @quiz.new_category.present?
      @quiz.category = Category.find_or_create_by!(
        name: @quiz.new_category.strip.titleize)
    end
  end

  def create_subject
   if @quiz.new_subject.present?
      @quiz.subject = Subject.find_or_create_by!(
        name: @quiz.new_subject.strip.titleize, category: @quiz.category) 
    end
  end

end
