require 'spec_helper'

describe "Questions" do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:quiz) { FactoryGirl.create(:quiz, author: user) }
  let(:question) { FactoryGirl.create( :question, quiz: quiz) }

  subject { page }

  before(:each) { valid_sign_in(user) }

  describe "when I visit the add new question page" do
    before(:each) do
      visit quiz_path(quiz)
      click_link "Add Question"
    end

    it { should have_content("New question") }
    specify { expect(current_path).to eq(new_question_path)}
    it { should have_button "Create Question" }
  end

  describe "when I add a question" do
    before(:each) do
      visit quiz_path(quiz)
      click_link "Add Question"
      fill_in "Question", with: question.content
      fill_in "Remarks", with: question.remarks 
      select question.question_type_description, :from => 'Question type'
      click_button "Create Question"
    end

    it { should have_content("Question was successfully created") }
    it { should have_content(question.content) }
  end

  describe "when I visit the edit question page" do
    before(:each) do
      question.save!
       visit quiz_path(quiz)
       click_link "edit"
    end
      it { should have_content("Edit question") }
      it { should have_button("Update Question") }
      it { should have_link("Cancel") }
  end

  describe "when I edit a question" do
    before(:each) do
      @new_question_text = "Modified question"
      question.save!
      visit quiz_path(quiz)
      click_link "edit"
      fill_in "Question", with: @new_question_text
      click_button "Update Question"
    end
    it "should return me to question's quiz page" do
      expect(current_path).to eq quiz_path(question.quiz)
    end
    it { should have_content(@new_question_text) }
  end

  describe "when I delete a question" do
    before(:each) do
      question.save!
      visit quiz_path(quiz)
    end

    it "should return to the show quiz page" do
      click_link "delete"
      expect(current_path).to eq quiz_path(question.quiz)
    end
    it "should delete the question" do
          expect do
            click_link "delete"
          end.to change(quiz.questions, :count).by(-1)
    end  
  end

  describe "when I copy a question" do
    it "should open the edit question page"
    it "should show a duplicate of the question"
    it "should save it as a new question"
  end

end
