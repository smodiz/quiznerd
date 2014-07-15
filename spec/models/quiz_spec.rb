require 'spec_helper'

describe Quiz do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:quiz) { FactoryGirl.create(:quiz, author: user) }

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

  describe "search" do
    let(:quiz_1) { FactoryGirl.create(:quiz, name: "Rails 101", author: user)  }
    let(:quiz_2) { FactoryGirl.create(:quiz, name: "Ruby 101", author: user) }
    let(:quiz_3) { FactoryGirl.create(:quiz, name: "jQuery", author: user) }

    before(:each) do
      quiz_1.save!
      quiz_2.save!
      quiz_3.save!
    end

    context "when given a search key word" do
      it "should return only the matching records" do
        @quizzes = Quiz.search("101")
        expect(@quizzes.count).to eq 2 
        @quizzes.each do |quiz|
          expect(quiz.name).to match(/101/)
        end
      end
    end

    context "when no search terms given" do
      it "should return all records" do
        @quizzes = Quiz.search("")
        expect(@quizzes.count).to eq 3
      end
    end
  end
end