require 'spec_helper'

describe "Quiz Pages" do

  let(:user) { FactoryGirl.create(:user) }
  let(:quiz) { FactoryGirl.create(:quiz, author: user) }

  subject { page }

  before(:each) { valid_sign_in(user) }

  describe "shows a quiz on the index page" do
    before(:each) do
      quiz.save
      visit quizzes_path
    end
    
    it { should have_content("Quizzes Written") }
    it { should have_content(quiz.name) }
    it { should have_content(quiz.description) }
    it { should have_content(quiz.category.name) }
    it { should have_content(quiz.subject.name) }
    it { should have_content(quiz.published ? "Yes" : "No") }
    it { should have_link("New Quiz") }
  end

  describe "does not show other users quiz" do
    let(:user2) { FactoryGirl.create(:user) }
    let(:quiz2) { FactoryGirl.create(:quiz, author: user2) }
    before(:each) do
      quiz2.save
      visit quizzes_path
    end
    it { should_not have_content(quiz2.name) }
  end

  describe "show new quiz page" do
    before(:each) do
      visit quizzes_path
      within(".page-actions") do
        click_link "New Quiz"
      end
    end

    it { should have_content("New quiz") }
    it { should have_button("Create Quiz") }
    it { should have_link("Cancel") }
  end

  describe "create new quiz" do
    before(:each) do
      visit quizzes_path
      within(".page-actions") do
        click_link "New Quiz"
      end
      fill_in "Name", with: quiz.name
      fill_in "Description", with: quiz.description
      select quiz.category.name, :from => 'Category'
      select quiz.subject.name, :from => 'Subject'
      click_button "Create Quiz"
    end

    it { should have_content("Quiz was successfully created") }
    it { should have_content(quiz.name) }
  end

  describe "cancel create new quiz" do
    before(:each) do
      visit quizzes_path
      within(".page-actions") do
        click_link "New Quiz"
      end
      click_link "Cancel"
    end
    it "should return to the quizzes list" do
      expect(current_path).to eq(quizzes_path)
    end
  end

  describe "delete a quiz" do
    before(:each) do
      quiz.save
      visit quizzes_path
      click_link("destroy")
    end

    it { should have_content("Quizzes Written")  }
    it { should_not have_content(quiz.name) }
  end

  describe "as wrong user" do
    let(:wrong_user) { FactoryGirl.create(:user) }
    let(:quiz) { FactoryGirl.create(:quiz, author: wrong_user) }

    describe "submitting a GET request to the Quizzes#edit action" do
      before { get edit_quiz_path(quiz) }
      specify { expect(current_path).to eq(root_path)}
    end

    describe "submitting a PATCH request to the Quizzes#update action" do
      before { patch quiz_path(quiz) }
      specify { expect(current_path).to eq(root_path)}
    end

    describe "submitting a DELETE request to the Quizzes#destroy action" do
      before { delete quiz_path(quiz) }
      specify { expect(current_path).to eq(root_path)}
    end
  end

  describe "show quiz" do
    before(:each) do 
      quiz.save!
      visit quizzes_path
      click_link quiz.name
    end
    
    specify { expect(current_path).to eq(quiz_path(quiz))}
    it { should have_content(quiz.name) }
    it { should have_link("Edit Quiz Information") }
    it { should have_link("Publish Quiz") }
    it { should have_content("Questions") }
    it { should have_link("Add Question") }
  end

 describe "edit quiz" do
    before(:each) do 
      quiz.save!
      visit quizzes_path
      click_link quiz.name
      click_link "Edit Quiz Information"
    end
    
    specify { expect(current_path).to eq(edit_quiz_path(quiz))}
    it { should have_content("Edit quiz") }
    it { should have_button("Update Quiz") }
    it { should have_link("Cancel") }

  end

end
