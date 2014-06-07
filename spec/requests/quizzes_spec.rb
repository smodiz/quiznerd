require 'spec_helper'

describe "Quiz Pages" do

  let(:user) { FactoryGirl.create(:user) }
  let(:quiz) { FactoryGirl.create(:quiz, author: user) }

  subject { page }

  describe "shows a quiz on the index page" do
    before(:each) do
      quiz.save!
      visit quizzes_path
    end
    
    it { should have_content("Quizzes Authored") }
    it { should have_content(quiz.name) }
    it { should have_content(quiz.description) }
    it { should have_content(quiz.category.name) }
    it { should have_content(quiz.subject.name) }
    it { should have_content(quiz.published ? "Yes" : "No") }
    it { should have_link("New Quiz") }
  end

 
end
