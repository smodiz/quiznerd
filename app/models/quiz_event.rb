class QuizEvent < ActiveRecord::Base
	belongs_to :user
	belongs_to :quiz
	before_save :process_question, on: :update 


	# these virtual attributes used for temporarily storing the 
	# current question_id and the user's answer, as well as their
	# answer to the last question so we can show the graded question
	attr_accessor :answer_ids, :question_id, :last_answer_ids, :last_answer_correct
	validates :answer_ids, presence: true, on: :update 

	COMPLETED_STATUS = "Completed"
	IN_PROGRESS_STATUS = "In Progress"

	def process_question
		if status == COMPLETED_STATUS
			self.errors.add(:status, "This quiz has already been completed.")
			return false
		end

		if question_id && last_question_id && 
							question_id.to_i <= last_question_id.to_i
			self.errors.add(:question_id, "Can't answer same question more than once")
			return false
		end

		if before_first_question?
			set_question_id
		else
			grade_question
			advance_to_next
		end
	end

	def last_question
		quiz.questions.find(last_question_id)
	end

	def current_question
		quiz.questions.find(question_id)
	end

	def before_first_question?
		total_answered == 0 && !question_id
	end

	def reset
		set_question_id
	end

	def current_question_number
		total_answered + 1
	end

	def question(question_number)
		return quiz.questions[question_number - 1]
	end
	
	def number_of_questions
		quiz.number_of_questions
	end

	def current_percent_grade
		if total_answered && total_correct && total_answered > 0
			(total_correct.to_f / total_answered.to_f) * 100
		else
			0
		end
	end

	def current_letter_grade
		case current_percent_grade
		when 90..100 	then "A"
		when 80..89		then "B"
		when 70..79		then "C"
		when 60..69		then "D"
		when 0..59		then "F"
		end
	end

	def number_of_questions
		quiz.questions.count
	end
	
	private

		def grade_question
			if answer_correct?
				self.total_correct += 1 
				self.last_answer_correct = true
			else
				self.last_answer_correct = false
			end
			self.total_answered += 1
		end

		def advance_to_next
			self.last_question_id = question_id
			self.last_answer_ids = answer_ids
			self.answer_ids = nil
			set_question_id
			self.status = COMPLETED_STATUS if completed?
		end

		def completed?
			self.total_answered == self.quiz.questions.count
		end

		def set_question_id 
			self.question_id = 
				if last_question_id
					quiz.questions.where("id > ?", last_question_id).first.try(:id)
				else
					quiz.questions.first.id 
				end
		end

	

		def answer_correct?
			current_question.correct_answer?(answer_ids)
		end

end
