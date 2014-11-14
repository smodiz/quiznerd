class CategoryPresentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    @quiz = record
    new_or_existing_category_required
  end

  def new_or_existing_category_required
    if @quiz.new_category.present? && @quiz.category.present?
       @quiz.errors.add(:category, "should be blank if new category selected")
    end
    if @quiz.new_category.blank? && @quiz.category.blank?
      @quiz.errors.add(:category, "should be selected or a new category entered")
    end
  end

end