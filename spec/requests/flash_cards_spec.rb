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
      expect(page).to have_css('.flash-card', text: card_1.sequence)
      expect(page).to have_css('.flash-card', text: card_1.front)
      expect(page).to have_css('.flash-card', text: card_1.back)
      expect(page).to have_css('.flash-card', text: card_2.sequence)
      expect(page).to have_css('.flash-card', text: card_2.front)
      expect(page).to have_css('.flash-card', text: card_2.back)
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