require 'spec_helper'

describe "Flash Deck Event Pages" do
  
  let(:deck) { FactoryGirl.create(:deck_with_flash_cards) }

  before(:each) do
    valid_sign_in(deck.user)
  end

  context "when starting" do
    it "shows the user options when they select Play" do
      visit deck_path(deck)
      click_link "Play Flash Cards"

      expect(page).to have_css('.deck-event-header', text: "#{deck.name}")
      expect(page).to have_css("#num_cards")
      expect(page).to have_css("#difficulty")
      expect(page).to have_css("#missed_filter")
      expect(page).to have_css("#order")
      expect(page).to have_button("Start!")
      expect(page).to have_css("tr.flash-card", count: deck.flash_cards.count)
    end
  end

  context "when choosing to filter" do
    it "returns a filtered set of flash cards" do
      visit deck_path(deck)
      click_link "Play Flash Cards"
      fill_in "num_cards", with: 3
      click_button "Start!"

      expect(page).to have_css('.deck-event-header', text: "#{deck.name}")
      expect(page).to have_css("tr.flash-card", count: 3)
    end
  end

  context "while playing" do  # just do happy path
    it "shows the first flash card (front) when user selects Start" 
    it "shows the back of the card when user clicks show" 
    it "allows user to select 'right' or 'wrong' to advance to next card" 
    it "shows each card in turn" 
    it "shows a score to the user at the end" 
  end

  context "when viewing past flash deck events" do
    it "shows previous deck events for that user"
    it "does not show previous events for other users" 
    it "allows the user to delete their own past events"
    it "does not allow the user to delete others' events"
  end

end 