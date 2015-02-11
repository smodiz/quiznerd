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
      expect(page).to have_css(".de-flash-card-side", count: (deck.flash_cards.count * 2))
    end
  end

  context "when choosing to filter" do
    it "returns a filtered set of flash cards" do
      visit deck_path(deck)
      click_link "Play Flash Cards"
      fill_in "num_cards", with: 3
      click_button "Start!"

      expect(page).to have_css('.deck-event-header', text: "#{deck.name}")
      expect(page).to have_css(".de-flash-card-side", count: (3*2))
    end
  end

  context "while playing" do
    before(:each) do
      play_deck = FactoryGirl.create(:deck_with_two_cards, user: deck.user)
      deck_event = DeckEvent.new_with_options(
        deck_id: play_deck.id, 
        user: play_deck.user
      )
      @deck_id = play_deck.id
      @first_card = deck_event.flash_card_set.first
      @second_card = deck_event.flash_card_set.last
      visit deck_path(play_deck)
      click_link "Play Flash Cards"
      fill_in "num_cards", with: 2
      click_button "Start!"
    end

    it "shows the first flash card (front) when user selects Start" do
      expect(page).to have_css('.de-flash-card-side', text: @first_card.front)
      
    end

    it "shows the back of the card when user clicks show" do
      click_link("advance-#{@first_card.id}")
      expect(page).to have_css('.de-flash-card-side', text: @first_card.back)
    end

    it "allows user to select 'correct' to advance to next card" do
      click_link("advance-#{@first_card.id}")
      click_link("correct-answer-#{@first_card.id}")
      expect(page).to have_css('.de-flash-card-side', text: @second_card.front)
    end

    it "allows user to select 'incorrect' to advance to next card" do
      click_link("advance-#{@first_card.id}")
      click_link("incorrect-answer-#{@first_card.id}")
      expect(page).to have_css('.de-flash-card-side', text: @second_card.front)
    end

    it "shows a score to the user at the end", js:true do
      click_link("advance-#{@first_card.id}")
      click_link("incorrect-answer-#{@first_card.id}")
      click_link("advance-#{@second_card.id}")
      click_link("correct-answer-#{@second_card.id}")
      expect(page).to have_content('You scored 50%!')
    end

    it "saves the deck_event if the user clicks save", js: true do
      click_link("advance-#{@first_card.id}")
      click_link("incorrect-answer-#{@first_card.id}")
      click_link("advance-#{@second_card.id}")
      click_link("correct-answer-#{@second_card.id}")
      click_button("Save")
      expect(page).to have_content("Your flash card study session was saved!")
      saved_event = DeckEvent.where(deck_id: @deck_id).first
      expect(saved_event.total_cards).to eq 2
      expect(saved_event.total_correct).to eq 1
      expect(saved_event.missed_cards_list).to eq @first_card.id.to_s
      expect(saved_event.user.id).to eq deck.user.id
    end
    it "does not save the event if the user clicks cancel" do
      click_link("advance-#{@first_card.id}")
      click_link("incorrect-answer-#{@first_card.id}")
      click_link("advance-#{@second_card.id}")
      click_link("correct-answer-#{@second_card.id}")
      click_link("Cancel")
      saved_event = DeckEvent.where(deck_id: @deck_id)
      expect(saved_event).to be_empty
    end

  end

  context "when viewing past flash deck events" do
    it "shows previous deck events for that user"
    it "does not show previous events for other users" 
    it "allows the user to delete their own past events"
    it "does not allow the user to delete others' events"
  end

end 