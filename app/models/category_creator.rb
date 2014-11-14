class CategoryCreator 

  def initialize(record)
    @record = record
  end

  def create
    if @record.new_category.present?
      @record.category = Category.find_or_create_by!(
        name: @record.new_category.strip.titleize)
    end
  end

end
