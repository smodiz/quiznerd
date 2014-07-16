require 'spec_helper'

describe QuizEvent do
  
  let(:quiz_author) { FactoryGirl.create(:user) }
  let(:quiz_taker)  { FactoryGirl.create(:user) }
  let(:quiz)        { FactoryGirl.create(:quiz_with_questions, author: quiz_author) }
  let(:quiz_event)  { FactoryGirl.create(:quiz_event, quiz: quiz, user: quiz_taker) }
  
  subject { quiz_event }

  describe "should respond to fields" do
    [:user, :quiz, :status, :total_correct, :total_answered, 
      :last_question_id, :answer_ids, :question_id, 
      :last_answer_ids, :last_answer_correct].each do |attr|
      it { should respond_to(attr) }
    end
  end

  describe "before answering first question" do

    it "should have correct current_question" do
      expect(quiz_event.question_id).to eq quiz_event.question(1).id
    end

    it "should have a total_answered of 0" do
      expect(quiz_event.total_answered).to eq 0
    end

    it "should have a total_correct of 0" do
      expect(quiz_event.total_correct).to eq 0
    end

    it "should have a nil last_question_id" do
      expect(quiz_event.last_question_id).to be_nil
    end

    it "should have a status of In Progress" do
      expect(quiz_event.status).to eq QuizEvent::IN_PROGRESS_STATUS
    end
  end


   shared_examples_for "after answering a question" do

    it "should have total_answered of 1" do
      expect(quiz_event.total_answered).to eq 1
    end

    it "should advance to the next question" do
      expect(quiz_event.question_id).to eq quiz_event.question(2).id
    end

    it "should have the correct last_question_id" do
       expect(quiz_event.last_question_id).to eq quiz_event.question(1).id     
    end

    it "should not allow answering the same question again" do
      quiz_event.question_id = quiz_event.last_question_id
      quiz_event.answer_ids = quiz_event.last_answer_ids
      expect(quiz_event.save).to be_false
      expect(quiz_event.errors[:question_id].join(" ")).to match(/cannot be answered more than once/i)
    end

    it "should have a status of In Progress" do
      expect(quiz_event.status).to eq QuizEvent::IN_PROGRESS_STATUS
    end
  end

  describe "after answering question correctly" do
    let(:correct_answer) { quiz_event.current_question.correct_answer_ids }
    before(:each) do 
      quiz_event.answer_ids = correct_answer
      quiz_event.save! 
    end
    it_behaves_like "after answering a question"
  
    it "should have total_correct of 1" do
      expect(quiz_event.total_answered).to eq 1
    end

    it "should have the correct last_answer_ids" do
      expect(quiz_event.last_answer_ids).to eq correct_answer
    end
  end

  describe "after answering question incorrectly" do
    let(:incorrect_answer) { quiz_event.current_question.incorrect_answer_ids }
    before(:each) do 
      quiz_event.answer_ids = incorrect_answer
      quiz_event.save! 
    end

    it_behaves_like "after answering a question"
  
    it "should have total_correct of 0" do
      expect(quiz_event.total_correct).to eq 0
    end

    it "should have the proper last_answer_ids" do
      expect(quiz_event.last_answer_ids).to eq incorrect_answer
    end
  end

  describe "after answering all the questions" do
    before(:each) do
      quiz_event.number_of_questions.times do |n|
        quiz_event.answer_ids = quiz_event.question(n).correct_answer_ids
        quiz_event.save! 
      end
    end

    it "should update the status to Completed" do
      expect(quiz_event.status).to eq QuizEvent::COMPLETED_STATUS
    end

    it "should have the right total_answered" do
      expect(quiz_event.total_answered).to eq quiz_event.number_of_questions
    end

    it "should have the right total_correct" do
      expect(quiz_event.total_answered).to eq quiz_event.number_of_questions        
    end

    it "should not allow answering a question again" do
      quiz_event.question_id = quiz_event.last_question_id
      quiz_event.answer_ids = quiz_event.last_answer_ids
      expect(quiz_event.save).to be_false
      expect(quiz_event.errors[:base].to_s).to match(/Completed/i)
    end
  end

  describe "grading" do
    it "should give 0 percent if no questions answered yet" do
      quiz_event.total_answered = 0
      expect(quiz_event.current_percent_grade).to eq 0
    end
 
    it "should give 0 percent if no questions answered correctly" do
      quiz_event.total_answered = 10
      quiz_event.total_correct = 0
      expect(quiz_event.current_percent_grade).to eq 0
    end

    it "should give the proper percentage" do
      quiz_event.total_answered = 4
      quiz_event.total_correct = 2
      expect(quiz_event.current_percent_grade).to eq 50
    end

  end

end
