class Question < ActiveRecord::Base
  
  belongs_to :quiz, touch: true, counter_cache: true
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true

  QUESTION_TYPES = {    "T/F"   =>  "True/False", 
                        "MC-1"  =>  "Multiple Choice - Single", 
                        "MC-2"  =>  "Multiple Choice - Multi"
                    }

  validates :content, presence: true
  validates :question_type, inclusion: { in: QUESTION_TYPES.keys }
  validate :must_have_multiple_answers, :must_have_correct_answer
  default_scope -> { order('created_at') }

  

  def self.new_with_answers(quiz_id)
    question = Question.new(quiz_id: quiz_id)
    4.times { question.answers.build }
    question
  end

  def question_type_description
    QUESTION_TYPES.include?(question_type) ? QUESTION_TYPES[question_type] : ""
  end

  def correct_answer?(answer_ids)
    if answer_ids.present?
     correct_answer_ids.sort == answer_ids.sort
    else
      false
    end
  end

  def correct_answer_ids
    answers.select { |a| a.correct == true }.map(&:id)
  end

  def incorrect_answer_ids
    answers.select { |a| a.correct == false }.map(&:id)
  end

private

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


end