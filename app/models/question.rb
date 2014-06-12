class Question < ActiveRecord::Base
  
  #Question types are not in the database because application logic (such as
  # fill-in-the-balnk has one answer T/F has 2 answers, etc) depends on these 
  # values, so they can't be changed independently of the code.
  QUESTION_TYPES = {    "T/F"   =>  "True/False", 
                        "MC-1"  =>  "Multiple Choice - Single", 
                        "MC-2"  =>  "Multiple Choice - Multi", 
                        "FIB"   =>  "Fill In the Blank"
                    }
  belongs_to :quiz
  has_many :answers
  accepts_nested_attributes_for :answers, allow_destroy: true
  
  validates :question_type, :content, :quiz_id, presence: true

  def question_type_description
    QUESTION_TYPES.include?(question_type) ? QUESTION_TYPES[question_type] : ""
  end
end
