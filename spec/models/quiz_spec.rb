require 'spec_helper'

describe Quiz do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:quiz) { FactoryGirl.create(:quiz, author: user) }

  subject { quiz }

  it { should be_valid }

  describe "should respond to fields" do
    [:name, :description, :category, :subject, :author, :published, 
      :new_category, :new_subject].each do |attr|
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
    let(:quiz_1) { FactoryGirl.create(:quiz_with_questions, name: "Rails 101", 
      author: user)  }
    let(:quiz_2) { FactoryGirl.create(:quiz_with_questions, name: "Ruby 101", 
      author: user) }
    let(:quiz_3) { FactoryGirl.create(:quiz_with_questions, name: "jQuery", 
      author: user) }
    let(:quiz_4) { FactoryGirl.create(:quiz, name: "CSS 101", author: user, published: false)  }

    before(:each) do
      quiz_1.save!
      quiz_2.save!
      quiz_3.save!
      quiz_4.save!
    end

    context "when given a search key word" do
      it "should return only the matching records for publishd quizzes" do
        @quizzes = Quiz.search_quiz_to_take("101")
        expect(@quizzes.size).to eq 2
        @quizzes.each do |quiz|
          expect(quiz.name).to match(/101/)
          expect(quiz.name).not_to match(/CSS/)
        end
      end
    end

    context "when no search terms given" do
      it "should return all records" do
        @quizzes = Quiz.search_quiz_to_take("")
        expect(@quizzes.size).to eq 3
      end
    end
  end

  describe "create a new category without a subject" do
    before(:each) do
      quiz.new_category = "Geography" 
      quiz.save
    end

    it { should_not be_valid }
    it "should have a validation error" do
      expect(quiz.errors.messages).to include(:new_subject)     
    end
  end

  describe "create a new category and subject" do
    before(:each) do
      quiz.category = nil
      quiz.subject = nil
      quiz.new_category = "Celebrities"
      quiz.new_subject = "Joan Rivers"
    end

    it "should create a new category" do
      expect { quiz.save! }.to change(Category, :count).by(1)
    end

    it "should create a new subject" do
      expect { quiz.save! }.to change(Subject, :count).by(1)
    end
  end

  describe "input existing category and a new category" do
    before(:each) do
      quiz.new_category = "Celebrities"
      quiz.save
    end

    it { should_not be_valid }
    it "should have a validation error" do
      expect(quiz.errors.messages).to include(:category)
    end
  end

  describe "input existing subject and a new subject" do
    before(:each) do
      quiz.new_subject = "Celebrities"
      quiz.save
    end

    it { should_not be_valid }
    it "should have a validation error" do
      expect(quiz.errors.messages).to include(:subject)
    end
  end

  describe "adding a new category that already exists" do
    before(:each) do
      quiz.new_category = quiz.category.name
      quiz.category = nil
      # this next part is required to pass validation
      quiz.new_subject = quiz.subject.name
      quiz.subject = nil
    end

    it "should not add an additional category" do
      expect { quiz.save! }.to change(Category, :count).by(0)
    end
  end

  describe "adding a new subject that already exists" do
    before(:each) do
      quiz.new_subject = quiz.subject.name
      quiz.subject = nil
    end

    it "should not add an additional subject" do
      expect { quiz.save! }.to change(Subject, :count).by(0)
    end  
  end

end
