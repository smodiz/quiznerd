require 'spec_helper'

describe Question do
  
  let(:quiz)      { FactoryGirl.create(:quiz_with_questions) }
  let(:question)  { FactoryGirl.create( :question, quiz: quiz) }
  let(:correct_answer) { FactoryGirl.build(:answer_correct) }
  let(:incorrect_answer) { FactoryGirl.build(:answer_incorrect) }

  subject { question }

  describe "should respond to fields" do
    [:question_type, :content, :remarks, :quiz, :answers].each do |field|
      it { should respond_to(field) }
    end
  end

  [:question_type, :content].each do |field|
    describe "when required field #{field} is absent" do
      before(:each) do
        question.send(field.to_s+"=",nil) 
        question.valid?
      end

      it { should_not be_valid }
      it  "should have an error for required field #{field} not set" do
        expect(question.errors.messages).to include(field)
      end
    end
  end

  describe "when valid" do
    before do
      question.answers << [correct_answer, incorrect_answer]
    end

    it { should be_valid }
  end

  describe "#question_type_label" do
      let(:question2) { 
        FactoryGirl.build(:question, quiz: quiz, question_type: "T/F") }
      let(:question3) { 
        FactoryGirl.build(:question, quiz: quiz, question_type: "BLAH") }
    it "has a valid question type" do
      expect(question2.question_type_description).to eq "True/False"
    end

    it "has no question type or invalid type" do
      expect(question3.question_type_description).to eq ""
    end
  end

  describe "#correct_answer?" do
    it "should return true when correct answer is provided" do
      expect(question.correct_answer?(
        question.correct_answer_ids)).to be_true
    end
    it "should return false when incorrect answer is provided" do
      expect(question.correct_answer?([9999999])).to be_false
    end
  end

  describe "with less than 2 answers" do
    before do
     question.answers = []
     question.valid?
   end
 
    it "should produce a validation error" do
      expect(question.errors[:answers].to_s).to match(/cannot be fewer than two/i)
    end
  end

  describe "with 2 answers" do
    before(:each) do
      question.answers << [incorrect_answer, incorrect_answer]
      question.valid?
    end
 
    it "should not produce a validation error" do
      expect(question.errors[:answers].to_s).to_not match(/cannot be fewer than two/i)
    end
  end

  describe "with no correct answers" do
    before(:each) do
      question.answers.each do |answer|
        answer.correct = false
      end
      question.valid?
    end

    it "should produce a validation error" do
      expect(question.errors[:answers].to_s).to match(/must have at least one which is correct/i)
    end
  end

  describe "with one correct answer" do
    before(:each) do
      question.answers << [correct_answer, incorrect_answer]
      question.valid?
    end

    it "should not produce a validation error" do
      expect(question.errors[:answers].to_s).to_not match(/must have at least one which is correct/i)
    end
  end  

end

