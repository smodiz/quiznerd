class Question < ActiveRecord::Base
  
  belongs_to :quiz
  has_many :answers, dependent: :destroy

  default_scope -> { order('id') }
  accepts_nested_attributes_for :answers, allow_destroy: true
  validates :question_type, :content, :quiz_id, presence: true



  # Question types are not in the database because application logic (such as
  # fill-in-the-blank has one answer, T/F has 2 answers, etc) depends on these 
  # values, so they can't be changed independently of the code.
  QUESTION_TYPES = {    "T/F"   =>  "True/False", 
                        "MC-1"  =>  "Multiple Choice - Single", 
                        "MC-2"  =>  "Multiple Choice - Multi"
                    }

  def question_type_description
    QUESTION_TYPES.include?(question_type) ? QUESTION_TYPES[question_type] : ""
  end

  def correct_answer?(answer_ids)
     correct_answer_ids.sort == answer_ids.sort
  end

  def correct_answer_ids
    answers.select { |a| a.correct == true }.map(&:id)
  end

  def incorrect_answer_ids
    answers.select { |a| a.correct == false }.map(&:id)
  end

  def all_answer_ids
    answers.map(&:id)
  end
end
