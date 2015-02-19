class FlashCardImporter

  attr_reader :deck

  def initialize(deck)
    @deck = deck
  end

  def import_from_quiz(quiz, difficulty=nil)
    @quiz = quiz
    @difficulty = difficulty
    deck.flash_cards = flash_cards_from_questions(start_sequence)
    deck.save
  end

  def errors
    deck.errors
  end

  private
  
  def start_sequence
    (@deck.flash_cards.map(&:sequence).max || 0 ) + 1
  end

  def flash_cards_from_questions(start_sequence)
    flash_cards = []
    @quiz.questions.each_with_index do |question, index|
      flash_cards << FlashCard.new( deck_id: @deck.id,
                                    front: build_front(question), 
                                    back: build_back(question),
                                    sequence: index + start_sequence,
                                    difficulty: @difficulty)
    end
    flash_cards
  end

  def build_back(question)
    "".tap do |back|
      back << get_answer(question.answers)
      back << get_remarks(question) if question.remarks.present?
    end
  end

  def get_answer(answers)
    answers.each_with_object("") { |a, back| back << "#{a.content}\n" if a.correct? }
  end 

  def get_remarks(question)
    "Remarks: \n\n #{question.remarks}" 
  end

  def build_front(question)
    if question.question_type == "T/F"
      "True or False:\n\n#{question.content}"
    else
      question.content
    end
  end

end
