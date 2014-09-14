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

  describe "#current_percent_grade" do
    context "when data present" do 
      it "returns the correct percentage" do 
        quiz_event.total_answered = 2
        quiz_event.total_correct = 1
        expect(quiz_event.current_percent_grade).to eq (50.0)
      end
    end

    context "when data not present" do 
      it "returns 0 when total_answered is not present" do 
        quiz_event.total_answered = nil
        quiz_event.total_correct = 5
        expect(quiz_event.current_percent_grade).to eq 0
      end
      it "returns 0 when total_answered is zero" do 
        quiz_event.total_answered = 0
        quiz_event.total_correct = 5
        expect(quiz_event.current_percent_grade).to eq 0
      end
      it "returns 0 when total_correct is not present" do
        quiz_event.total_answered = 5
        quiz_event.total_correct = nil
        expect(quiz_event.current_percent_grade).to eq 0        
      end
    end
  end

end
