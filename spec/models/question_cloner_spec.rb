require 'spec_helper'

describe QuestionCloner do 

  let(:quiz)      { FactoryGirl.create(:quiz_with_questions) }
  let(:question)  { FactoryGirl.create( :question, quiz: quiz) }
 

  describe "#clone" do
    let(:clone) { QuestionCloner.clone(question) }

    it "should copy the question content" do
      expect(clone.content).to eq question.content
    end

    it "should copy the quiz_id" do
      expect(clone.content).to eq question.content
    end

    it "should copy all the answers" do
      expect(clone.answers.map(&:content)).to eq question.answers.map(&:content)
    end
  end

end
