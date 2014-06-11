require 'spec_helper'

describe Question do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:quiz) { FactoryGirl.create(:quiz, author: user) }
  let(:question) { FactoryGirl.create( :question, quiz: quiz) }

  subject { question }

  it { should be_valid }

  describe "should respond to fields" do
    [:question_type, :content, :remarks, :quiz].each do |field|
      it { should respond_to(field) }
    end
  end

  [:question_type, :content, :quiz_id].each do |field|
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

  describe "#question_type_label" do
      let(:question2) { 
        FactoryGirl.create(:question, quiz: quiz, question_type: "FIB") }
      let(:question3) { 
        FactoryGirl.create(:question, quiz: quiz, question_type: "BLAH") }
    it "has a valid question type" do
      expect(question2.question_type_description).to eq "Fill In the Blank"
    end

    it "has no question type or invalid type" do
      expect(question3.question_type_description).to eq ""
    end
  end

end

