class SubjectCreator 

  def initialize(record)
    @record = record
  end

  def create
    if @record.new_subject.present?
      @record.subject = Subject.find_or_create_by!(
        name: @record.new_subject.strip.titleize, 
        category: @record.category || @record.new_category) 
    end
  end

end
