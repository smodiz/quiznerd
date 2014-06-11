require 'spec_helper'

describe "Static Pages" do

  subject { page }

  
  describe "Home page" do
    before(:each) { visit root_path }

    context "when not signed in" do
      it { should have_content('Welcome to QuizNerd') }
      it { should have_title(full_title('')) }
      it { should_not have_title('| Home') }   
      it { should have_link('Sign up now!') }   
    end

    context "when signed in" do
      let(:user) { FactoryGirl.create(:user) }
      let(:quiz) { FactoryGirl.create(:quiz, author: user) }

      before(:each) do
        quiz.save
        valid_sign_in(user) 
      end

      describe "should show user specific home page" do
        it { should have_content("Quizzes Written") }
        it { should have_content("Quizzes Taken") }
        it { should have_link('New Quiz') }
        it { should have_link('Search for a Quiz') }
      end

      describe "when I click the New Quiz link" do
        before(:each) do
          within(".home-page") do
          click_link "New Quiz"
          end
        end
        specify { expect(current_path).to eq(new_quiz_path) } 
      end

      describe "when I click the 'Search for a Quiz' link" do
        before { click_link "Search for a Quiz" }
        it "should go to the search page"
        #specify { expect(current_path).to eq(?) }
      end        
    end
  end

  describe "About page" do
    before(:each) { visit about_path }
    it { should have_content('About') }
    it { should have_title(full_title('About')) }
  end

  describe "Contact page" do
    before(:each) { visit contact_path }
    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end

  it  "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    expect(page).to have_title(full_title(''))
  end
  
  describe "Click Logo" do
    before { visit contact_path }
    it "should go to the home page" do
      click_link "QuizNerd"
      expect(page).to have_title(full_title(''))
    end
  end
end
