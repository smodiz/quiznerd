require 'spec_helper'

describe "Cheatsheets Pages" do 
  let(:user) { FactoryGirl.create(:user) }

  subject { page }

  before(:each) do
    valid_sign_in(user) 
  end

  describe "the menu" do
    it "shows the cheatsheets index link" do
      visit root_path
      expect(page).to have_link("My Cheatsheets")
      click_link "My Cheatsheets"
      expect(current_path).to eq(cheatsheets_path) 
    end
    it "shows a link for creating a new cheatsheet" do
      visit root_path
      expect(page).to have_link("New Cheatsheet")
      click_link "New Cheatsheet"
      expect(current_path).to eq(new_cheatsheet_path) 
    end
  end

  describe "show a quiz on the index page" do 
    before(:each) do
      @cs = FactoryGirl.create(:cheatsheet, user: user)
      visit cheatsheets_path
    end
    it { should have_content("Cheatsheets") }
    it { should have_link(@cs.title) }
    it { should have_link("New Cheatsheet")}

  end 

  describe  "show pagination links on index page" do
    before(:each) do
      (Cheatsheet.per_page + 1).times { FactoryGirl.create(:cheatsheet, user: user) }
      visit cheatsheets_path
    end

    it { should have_link("Next") }
    it "clicking next link navigates to the next page" do
      click_link "Next"
      expected_cheatsheet = Cheatsheet.last.title
      unexpected_cheatsheet = Cheatsheet.first.title
      expect(page).to have_content expected_cheatsheet
      expect(page).not_to have_content unexpected_cheatsheet
    end
  end

  describe "cannot see someone else's cheatsheet" do
    before(:each) do
      not_me      =   FactoryGirl.create(:user)
      @my_cs      =   FactoryGirl.create(:cheatsheet, user: user)
      @not_my_cs  =   FactoryGirl.create(:cheatsheet, user: not_me)
      visit cheatsheets_path
    end
    it { should_not have_link(@not_my_cs.title)}
    it { should have_link(@my_cs.title) }
  end

  describe "as wrong user" do
    before(:each) do
      other_user = FactoryGirl.create(:user)
      @cs = FactoryGirl.create(:cheatsheet, user: other_user)
      @cs
    end

    describe "submit a GET request to Cheatsheets#edit action" do
      before { get edit_cheatsheet_path(@cs) }
      specify { expect(current_path).to eq root_path }
    end
    describe "submit a PATCH request to Cheatsheets#edit action" do
      before { patch cheatsheet_path(@cs) }
      specify { expect(current_path).to eq root_path } 
    end
    describe "submit a DELETE request to Cheatsheets#edit action" do
      before { delete cheatsheet_path(@cs) }
      specify { expect(current_path).to eq root_path }
    end
  end


  describe "create a new cheatsheet" do
    it "creates a new cheatsheet" do
      visit new_cheatsheet_path
      expect(page).to have_css ".section-header", text: "New Cheatsheet"
      fill_in "Title", with: "A new cheatsheet"
      fill_in "Content", with: "Something of interest!"
      click_button "Create Cheatsheet"
      expect(page).to have_css ".section-header", text: "A new cheatsheet"
      expect(page).to have_content "Something of interest!"
    end

    it "returns to the index page when canceled" do
      visit new_cheatsheet_path
      expect(page).to have_css ".section-header", text: "New Cheatsheet"
      click_link "Cancel"
      expect(current_path).to eq cheatsheets_path
    end
  end

  describe "delete a cheatsheet" do
    before(:each) do
      @cs = FactoryGirl.create(:cheatsheet, user: user)
      visit cheatsheets_path
    end

    it "deletes a cheatsheet" do
      expect(page).to have_content @cs.title
      click_link "delete-link"
      expect(page).to_not have_content @cs.title
      expect(current_path).to eq cheatsheets_path
    end
  end

  describe "modify a cheatsheet" do
    before(:each) do
      @cs = FactoryGirl.create(:cheatsheet, user: user)
    end

    it "modifies a cheatsheet" do
      visit cheatsheets_path
      click_link "edit-link"
      expect(page).to have_css ".section-header", text: @cs.title
      fill_in "Content", with: "new content"
      click_button "Update Cheatsheet"
      expect(Cheatsheet.find(@cs.id).content).to eq "new content"
      expect(current_path).to eq cheatsheet_path(@cs)
    end

   it "returns to the index page when canceled" do
      visit cheatsheets_path
      click_link "edit-link"
      expect(page).to have_css ".section-header", text: @cs.title
      click_link "Cancel"
      expect(current_path).to eq cheatsheets_path
    end
  end

  describe "display a cheatsheet" do
    it "displays a cheatsheet" do
      @cs = FactoryGirl.create(:cheatsheet, user: user)
      visit cheatsheets_path
      click_link @cs.title
      expect(page).to have_css ".section-header", text: @cs.title
      expect(page).to have_content @cs.content
    end
  end

  describe "search cheatsheets" do
    before(:each) do
      @cs1 =FactoryGirl.create(:cheatsheet, user: user)
      @cs2 =FactoryGirl.create(:cheatsheet, user: user)
      visit cheatsheets_path
      fill_in "search", with: @cs2.title
      click_button "Search"
    end

    it "displays the matching cheatsheets" do
      expect(page).to have_css ".index-section-header", text: "Cheatsheets"
      expect(page).to have_content @cs2.title
    end

    it "does not display non-matching cheatsheets" do
      expect(page).to have_css ".index-section-header", text: "Cheatsheets"
      expect(page).not_to have_content @cs1.title
    end
  end

  describe "adding a tag to a cheat sheet" do
    it "adds a tag" do
      @cs1 = FactoryGirl.create(:cheatsheet, user: user)
      visit edit_cheatsheet_path @cs1
      fill_in "cheatsheet[tag_list]", with: "tag1, tag2"
      click_button "Update Cheatsheet"
      expect(@cs1.reload.tag_list).to eq "tag1, tag2"
    end
  end

  describe "removing a tag from a cheatsheet" do
    it "removed the tag" do
      @cs1 = FactoryGirl.create(:cheatsheet, user: user)
      @cs1.tag_list = "tag1, tag2"
      @cs1.save!
      visit edit_cheatsheet_path @cs1
      fill_in "cheatsheet[tag_list]", with: "tag1"
      click_button "Update Cheatsheet"
      expect(@cs1.reload.tag_list).to eq "tag1"
    end
  end

  describe "displaying cheatsheets by tag" do
    it "displays only the matching cheatsheets" do
      @cs1 = FactoryGirl.create(:cheatsheet, user: user)
      @cs2 = FactoryGirl.create(:cheatsheet, user: user)
      @cs1.tag_list = "tag1, tag2"
      @cs1.save!
      visit cheatsheets_path
      expect(page).to have_link("tag1")
      expect(page).to have_link("tag2")
      click_link "tag1"
      expect(page).to have_content @cs1.title
      expect(page).to_not have_content @cs2.title
    end
  end

end 

