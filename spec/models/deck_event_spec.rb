require 'spec_helper'

describe DeckEvent do
  let(:deck) { FactoryGirl.create(:deck_with_flash_cards) }
  let(:deck_event) do
    FactoryGirl.create(:deck_event, deck_id: deck.id, user_id: deck.user_id)
  end

  subject { deck_event }

  before(:each) do
    deck
    deck_event
  end

  describe '#valid' do
    [:total_cards, :total_correct].each do |attr|
      it "is not valid when #{attr} is nil" do
        deck_event.send("#{attr}=", nil)
        expect(deck_event).not_to be_valid
        expect(deck_event.errors).to include(attr)
      end
    end
  end
end
