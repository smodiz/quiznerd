require 'spec_helper'

describe FlashCardImporter do

  let(:quiz)    { FactoryGirl.create(:quiz_with_questions) }
  let(:deck)    { FactoryGirl.create(:deck) }
  let(:deck_2)  { FactoryGirl.create(:deck_with_two_cards) }

  describe "created from quiz questions" do
    it "adds flash cards to deck" do
      default_difficulty = "2"
      # factory creates 2 questions, each with 2 answers, 
      # one of which is correct. For a more complete test,
      # make one of the questions have 2 correct answers
      quiz.questions.first.answers[1].correct = true
      importer = FlashCardImporter.new(deck)
      importer.import_from_quiz(quiz, default_difficulty)

      expect(deck.flash_cards.size).to eq quiz.questions.size
      deck.flash_cards.each_with_index do |flash_card, index|
        expect(question_equivalent?(  flash_card, 
                                      quiz.questions[index],
                                      default_difficulty)
        ).to eq true
      end
    end
  end

  def question_equivalent?(flash_card, question, difficulty)
    flash_card.front.include?(question.content) && 
      answer_equivalent?(question.answers, flash_card) && 
      flash_card.difficulty == difficulty
  end

  def answer_equivalent?(answers, flash_card)
    answers.any? do |a| 
      #xnor -> expect either true && true or false && false
      !(flash_card.back.include?(a.content) ^ a.correct?)
    end
  end
end