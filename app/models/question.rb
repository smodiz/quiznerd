class Question < ActiveRecord::Base
  
  belongs_to :quiz, touch: true
  has_many :answers, dependent: :destroy

  default_scope -> { order('created_at') }
  accepts_nested_attributes_for :answers, allow_destroy: true
  validates :question_type, :content, presence: true
  validate :must_have_multiple_answers, :must_have_correct_answer

  # Question types are not in the database because application logic (such as
  # fill-in-the-blank has one answer, T/F has 2 answers, etc) depends on these 
  # values, so they can't be changed independently of the code.
  QUESTION_TYPES = {    "T/F"   =>  "True/False", 
                        "MC-1"  =>  "Multiple Choice - Single", 
                        "MC-2"  =>  "Multiple Choice - Multi"
                    }

  def self.new_with_answers(quiz_id)
    question = Question.new(quiz_id: quiz_id)
    4.times { question.answers.build }
    question
  end

  def must_have_multiple_answers
    if answers.size < 2
      errors.add(:answers, "cannot be fewer than two")
    end
  end

  def must_have_correct_answer
    if correct_answer_ids.size < 1 
      errors.add(:answers, "must have at least one which is correct")
    end
  end

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


end