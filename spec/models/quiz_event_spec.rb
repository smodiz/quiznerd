require 'spec_helper'

describe QuizEvent do
  
  let(:quiz_event)  { FactoryGirl.create(:quiz_event) }
  let(:number_of_questions) { quiz_event.number_of_questions }
  
  subject { quiz_event }

  describe "should respond to fields" do
    [:user, :quiz, :status, :total_correct, :total_answered, 
      :last_question_id].each do |attr|
      it { should respond_to(attr) }
    end
  end
  
  describe "#update_status" do

    it "updates the status when all the questions have been answered" do
      expect(quiz_event).not_to be_completed
      quiz_event.total_answered = number_of_questions
      expect(quiz_event).to be_completed
    end

    it "does not update status unless all the questions have been answered" do
      quiz_event.should_receive(:number_of_questions).and_return(number_of_questions)
      quiz_event.total_answered = (number_of_questions.to_i - 1 )
      expect(quiz_event).not_to be_completed
    end

  end

end
