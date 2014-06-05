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
      it "should show user specific page" 
      it "should show changes in the navigation links"
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
