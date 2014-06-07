require 'spec_helper'

describe Quiz do
  
  let(:quiz) { FactoryGirl.create(:quiz, author: FactoryGirl.create(:user)) }

  subject { quiz }

  it { should be_valid }

  describe "should respond to fields" do
    [:name, :description, :category, :subject, :author, :published].each do |attr|
      it { should respond_to(attr) }
    end
  end

  [:name, :description, :category, :subject, :author, :published].each do |attr|
    describe "when required field #{attr} is nil" do
      before(:each) do
        quiz.send(attr.to_s + "=",nil)
        quiz.valid?
      end 
      it { should_not be_valid }
      it  "should have an error for required field #{attr} not set" do
        expect(quiz.errors.messages).to include(attr)
      end
    end
  end

end
