class CategorySubjectValidator < ActiveModel::Validator

  def validate(record)
    @quiz = record
    new_category_requires_subject
    new_or_existing_category_required
    new_or_existing_subject_required
  end

  private

  def new_category_requires_subject
    if  @quiz.new_category.present? &&  @quiz.new_subject.blank?
       @quiz.errors.add(:new_subject, "is required for a new category")
    end
  end

  def new_or_existing_category_required
    if @quiz.new_category.present? && @quiz.category.present?
       @quiz.errors.add(:category, "should be blank if new category selected")
    end
    if @quiz.new_category.blank? && @quiz.category.blank?
      @quiz.errors.add(:category, "should be selected or a new category entered")
    end
  end

  def new_or_existing_subject_required
    if  @quiz.new_subject.present? &&  @quiz.subject.present?
       @quiz.errors.add(:subject, "should be blank if new subject selected")
    end
    if  @quiz.new_category.blank? &&  @quiz.new_subject.blank? && 
         @quiz.subject.blank?
       @quiz.errors.add(:subject, "should be selected or a new subject entered")
    end
  end

end