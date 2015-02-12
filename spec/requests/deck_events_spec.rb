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
      deck_event = DeckEvent.new_for(
        deck_id: play_deck.id, 
        user: play_deck.user
      )
      @deck_id = play_deck.id
      @first_card = deck_event.deck.flash_cards.first
      @second_card = deck_event.deck.flash_cards.last
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
      click_link("incorrect-answer-#{@second_card.id}")
      click_button("Save")
      expect(page).to have_content("Your flash card study session was saved!")
      saved_event = DeckEvent.where(deck_id: @deck_id).first
      expect(saved_event.total_cards).to eq 2
      expect(saved_event.total_correct).to eq 0
      expect(saved_event.missed_cards_list).to eq [@first_card.id,@second_card.id].join(",")
      expect(saved_event.user.id).to eq deck.user.id
    end
    it "does not save the event if the user clicks cancel" do
      click_link("advance-#{@first_card.id}")
      click_link("incorrect-answer-#{@first_card.id}")
      click_link("advance-#{@second_card.id}")
      click_link("correct-answer-#{@second_card.id}")
      within('#new_deck_event') do
        click_link("Cancel")
      end
      saved_event = DeckEvent.where(deck_id: @deck_id)
      expect(saved_event).to be_empty
    end

  end

  context "when viewing past flash deck events" do
    before(:each) do
      deck_2 = FactoryGirl.create(:deck_with_flash_cards) #diff user
      deck_3 = FactoryGirl.create(:deck) #diff user
      # events 1 and 2 are for deck.user. Note that one of the decks was
      # not created by deck.user, but a user should be able to play
      # someone else's deck 
      @event_1 = FactoryGirl.create(:deck_event, 
          deck_id: deck.id, 
          user: deck.user
      )
      @event_2 = FactoryGirl.create(:deck_event, 
          deck_id: deck_2.id, 
          user: deck.user, 
          total_correct: 4
      )
      # third event is from another user and should not show on our events page
      @event_3 = FactoryGirl.create(:deck_event, deck_id: deck_3.id, user: deck_3.user)
    end

    it "shows previous deck events for that user and not others" do
      visit deck_events_path
      expect(page).to have_css('.section-header', text: "Flash Card Study History")
      expect(page).to have_content(@event_1.name)
      expect(page).to have_content(score_string(@event_1))
      expect(page).to have_content(@event_2.name)
      expect(page).to have_content(score_string(@event_2))
      expect(page).not_to have_content(@event_3.name)
    end
  end

  it "allows the user to delete their own past events" do
    event = FactoryGirl.create(:deck_event, user: deck.user)
    visit deck_events_path
    expect(page).to have_content(event.name)
    click_link("delete")
    expect(page).not_to have_content(event.name)
    expect(DeckEvent.where(id: event.id)).to be_empty
  end


  describe "as wrong user" do
    # there's no show, edit, or update action for DeckEvent, so
    # just need to check that the delete action is only available
    # for the user that the event belongs to
    it "does not allow deleting" do
      different_user = FactoryGirl.create(:user)
      @event = FactoryGirl.create(:deck_event, user: different_user) 
      delete deck_event_path(@event)
      expect(current_path).to eq root_path
      expect(DeckEvent.where(id: @event.id).size).to eq 1
    end
  end

  describe "the menu" do
    it "shows the flash deck event index link" do
      visit root_path
      expect(page).to have_link("Flash Decks Studied")
      click_link "Flash Decks Studied"
      expect(current_path).to eq(deck_events_path) 
    end
  end

  def score_string(deck_event)
    correct = deck_event.total_correct
    total = deck_event.total_cards
    score = ((correct.to_f/total)*100).to_i
    "#{score}% (#{correct} out of #{total})"
  end
end 