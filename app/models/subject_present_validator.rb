class SubjectPresentValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    @quiz = record
    new_or_existing_subject_required
    new_category_requires_subject
  end

  def new_category_requires_subject
    if  @quiz.new_category.present? &&  @quiz.new_subject.blank?
       @quiz.errors.add(:new_subject, "is required for a new category")
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

