class CategorySubjectCreator 

  def initialize(record)
    @record = record
  end

  def create
    if @record.valid?
      create_category
      create_subject
    end
  end

  def create_category
    if @record.new_category.present?
      @record.category = Category.find_or_create_by!(
        name: @record.new_category.strip.titleize)
    end
  end

  def create_subject
   if @record.new_subject.present?
      @record.subject = Subject.find_or_create_by!(
        name: @record.new_subject.strip.titleize, category: @record.category) 
    end
  end

end
