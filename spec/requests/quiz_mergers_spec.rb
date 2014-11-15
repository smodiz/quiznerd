require 'spec_helper'

describe "Quiz Merger Page" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) { valid_sign_in(user) }

    it "displays source and target" do
      visit new_quiz_merges_path
      expect(page).to have_css "#quiz_merge_source_quiz_id"
      expect(page).to have_css "#quiz_merge_target_quiz_id"
    end

    it "merges the quizzes" do
      source = FactoryGirl.create(:quiz_with_questions, author_id: user.id) 
      target = FactoryGirl.create(:quiz_with_questions, author_id: user.id) 
      
      visit new_quiz_merges_path
      select source.name, :from => 'Source Quiz'
      select target.name, :from => 'Target Quiz'
      click_button "Create"

      expect(page).to have_css ".alert", text: "Merge completed successfully"
      
      modified_quiz_questions = Quiz.find(target.id).questions.map{ |q| q.id }

      expect(modified_quiz_questions).to include source.questions.first.id
    end
end