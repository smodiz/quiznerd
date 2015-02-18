class DeckBuilder

  def self.from_quiz(quiz, difficulty=nil)
    deck = Deck.new(  
      name:         quiz.name, 
      description:  quiz.description, 
      status:       Deck::STATUSES[0],
      user:         quiz.author, 
      tag_list:     quiz.subject_name.downcase.gsub(" ", "-")
    )
    deck.flash_cards = self.flash_cards_from_questions(
      deck.id, 
      difficulty, 
      quiz.questions
    )
    deck
  end

  private
  
  def self.flash_cards_from_questions(deck_id, difficulty, questions)
    flash_cards = []
    questions.each_with_index do |question, index|
      flash_cards << FlashCard.new( deck_id: deck_id,
                                    front: self.build_front(question), 
                                    back: self.build_back(question),
                                    sequence: index + 1,
                                    difficulty: difficulty)
    end
    flash_cards
  end

  def self.build_back(question)
    "".tap do |back|
      back << get_answer(question.answers)
      back << get_remarks(question) if question.remarks.present?
    end
  end

  def self.get_answer(answers)
    answers.each_with_object("") { |a, back| back << "#{a.content}\n" if a.correct? }
  end 

  def self.get_remarks(question)
    "Remarks: \n\n #{question.remarks}" 
  end

  def self.build_front(question)
    if question.question_type == "T/F"
      "True or False:\n\n#{question.content}"
    else
      question.content
    end
  end

end
