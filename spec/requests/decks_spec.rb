require 'spec_helper'

describe "Flash Deck Pages" do 

  let(:deck) { FactoryGirl.create(:deck) }

  subject { page }

  before(:each) do
    deck
    valid_sign_in(deck.user)
  end
  
  describe "index page" do
    before(:each) do
      @another_deck = FactoryGirl.create(:deck)
      visit decks_path
    end

    it { should have_css('div', text: "Flash Decks") }
    it { should have_content(deck.name) }
    it { should have_link("edit") }
    it { should have_link("destroy") }
    it { should have_link("New Flash Deck") }

    it "does not show other users decks" do
      expect(page).not_to have_content(@another_deck.name)
    end
  end

  describe "creating a new flash deck" do
    it "creates a new deck" do
      decks_count = Deck.all.count
      visit decks_path
      within(".page-actions") do
        click_link "New Flash Deck"
      end
      fill_in "Name", with: "Fun With Rails"
      fill_in "Description", with: "Test your knowledge of fun."
      select "Private", from: "Status"
      click_button "Create"
      
      expect(page).to have_content("Deck was successfully saved")
      expect(page).to have_css(".section-header", text: "Fun With Rails")
      expect(Deck.all.count).to eq (decks_count + 1)
    end

  end

  describe "show flash deck"  do #will show cards and create cards, too
    it "shows the deck" do
      visit decks_path
      click_link deck.name
      expect(page).to have_css(".section-header", text: deck.name)
      expect(page).to have_css(".breadcrumb li", text: "My Flash Decks")
      expect(page).to have_css(".breadcrumb li", text: "Show Flash Deck")
      expect(page).to have_content(deck.status)
      expect(page).to have_content(deck.description)
    end
    it "deletes the deck when delete button is clicked" do
      visit deck_path(deck)
      click_link "Delete"
      expect(Deck.where(id: deck.id)).to be_empty
      expect(page).to have_content("Deck was successfully destroyed")
      expect(page).to have_css('div', text: "Flash Decks") 
      expect(current_path).to eq(decks_path)
    end
    it "shows the edit page when edit button is clicked" do
      visit deck_path(deck)
      click_link "Edit"
      expect(current_path).to eq(edit_deck_path(deck))
    end
  end

  describe "delete flash deck" do
    before(:each) do
      visit decks_path
    end

    it "deletes a deck when the link is clicked" do
      click_link "destroy"
      expect(page).not_to have_content(deck.name)
      expect(Deck.where(id: deck.id)).to be_empty
      expect(current_path).to eq(decks_path)
    end
  end

  describe "update flash deck" do
    before(:each) do
      visit decks_path
      click_link "edit"
    end

    it "updates the deck" do
      expect(page).to have_css(".section-header", text: "Edit Flash Deck")
      expect(page).to have_css(".breadcrumb li", text: "My Flash Decks")
      fill_in "Name", with: "New name"
      click_button "Update Deck"

      expect(page).to have_content("Deck was successfully saved")
      expect(current_path).to eq(deck_path(deck))
    end
    it "returns to the index page when cancel is clicked" do
      click_link "Cancel"
      expect(current_path).to eq(decks_path)
    end

  end

end
