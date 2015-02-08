require 'spec_helper'

describe "Flash Card Pages" do
  

  let(:deck)    { FactoryGirl.create(:deck) }
  let(:card_1)  { FactoryGirl.create(:flash_card, deck: deck) }
  let(:card_2)  { FactoryGirl.create(:flash_card, deck: deck) }

  subject { page }

  before(:each) do
    
    deck; card_1; card_2
    valid_sign_in(deck.user)
  end

  describe "index page" do
    it "displays all the flash cards of the deck" do
      visit deck_path(deck)
      expect(page).to have_css('.flash-card', text: card_1.front)
      expect(page).to have_css('.flash-card', text: card_1.back)
      expect(page).to have_css('.flash-card', text: card_2.front)
      expect(page).to have_css('.flash-card', text: card_2.back)
    end
  end

  describe "create", js:true do
    it "creates a new flash card record" do
      visit deck_path(deck)
      click_link "Add Flash Card"
      fill_in "front", with: "Flash card front"
      fill_in "back", with: "Flash card back"
      find('#flash_card_difficulty').select "Beginner"
      click_button "Save"
      expect(page).to have_css('.flash-card', text: "Flash card front")
      expect(page).to have_css('.flash-card', text: "Flash card back")
    end
  end

  describe "update", js:true do
    it "updates the flash card" do
      visit deck_path(deck)
      within ".flash-card", :match => :first do
        click_link "edit", :match => :first
      end
      fill_in "front", with: "Flash card front"
      fill_in "back", with: "Flash card back"
      find('#flash_card_difficulty').select "Beginner"
      click_button "Save"
      expect(page).to have_css('.flash-card', text: "Flash card front")
      expect(page).to have_css('.flash-card', text: "Flash card back")
    end
  end

  describe "delete" do
    it "deletes the record when the delete link is clicked" do
      visit deck_path(deck)
      within ".flash-card", :match => :first do
        click_link "delete", :match => :first
      end
      expect(page).not_to have_css('.flash-card', text: card_1.front)
    end
  end



end