require 'spec_helper'

describe FlashCardSetBuilder do

  let(:deck) { FactoryGirl.create(:deck_with_flash_cards) }  

  describe "#generate_deck" do

    context "with all options set to nil" do
      it "provides all the flash_cards" do
        flash_card_set = FlashCardSetBuilder.new(deck).generate_flash_cards
        
        expect(flash_card_set).to match_array(deck.flash_cards)
      end
    end    

    context "with number of cards set to > 0" do
      it "provides the correct number of flash_cards" do
        builder = FlashCardSetBuilder.new(deck, {num_cards: 3})

        flash_card_set = builder.generate_flash_cards
        
        expect(flash_card_set.size).to eq 3
        expect(flash_card_set.map(&:sequence)).to eq flash_card_set.map(&:sequence).sort        
      end
    end

    context "with a non-nil difficulty level" do
      it "filters the flash cards according to the difficulty" do
        deck.flash_cards.last.update_attribute(:difficulty, "2")
        builder = FlashCardSetBuilder.new(deck, {difficulty: "1"})

        flash_card_set = builder.generate_flash_cards
        
        expect(flash_card_set).to match_array(deck.flash_cards[0..3])
      end
    end

    context "with a missed filter of :last_missed" do
      it "returns the flash cards that were missed the last time" do
        deck_event = FactoryGirl.create(  
          :deck_event, 
          deck_id: deck.id,
          user_id: deck.user_id,
          missed_cards_list: deck.flash_cards[0..1].map(&:id).map(&:to_s).join(",")
        )
        builder = FlashCardSetBuilder.new(deck, { missed_filter: :last_missed })

        flash_card_set = builder.generate_flash_cards
        
        expect(flash_card_set).to match_array(deck.flash_cards[0..1])
      end
    end

    context "with a missed filter of :ever_missed" do
      it "returns all flash cards from the given deck that user ever missed" do
        deck_event = FactoryGirl.create(  
          :deck_event, 
          deck_id: deck.id,
          user_id: deck.user_id,
          missed_cards_list: deck.flash_cards[0..1].map(&:id).map(&:to_s).join(",")
        )
        deck_event = FactoryGirl.create(  
          :deck_event, 
          deck_id: deck.id,
          user_id: deck.user_id,
          missed_cards_list: deck.flash_cards[1,2].map(&:id).map(&:to_s).join(",")
        )
        builder = FlashCardSetBuilder.new(deck, { missed_filter: :ever_missed })

        flash_card_set = builder.generate_flash_cards

        expect(flash_card_set).to match_array(deck.flash_cards[0..2])
      end
    end

    context "with random order" do
      it "returns the flash cards it should but not in orig order" do
        builder = FlashCardSetBuilder.new(deck, { order: :random })

        flash_card_set = builder.generate_flash_cards
        
        expect(flash_card_set.map(&:id)).not_to eq deck.flash_cards.map(&:id)
        expect(flash_card_set.map(&:id).sort).to eq deck.flash_cards.map(&:id)
      end
    end

    context "with all options set to non-nil" do
      it "returns the correct flash cards" do
        missed_cards_list = deck.flash_cards[0,4].map(&:id).map(&:to_s).join(",")
        deck_event = FactoryGirl.create(  
          :deck_event, 
          deck_id: deck.id,
          user_id: deck.user_id,
          missed_cards_list: missed_cards_list
        )
        deck.flash_cards.first.update_attribute(:difficulty, "2")
        possible_cards = deck.flash_cards[1,3]
        builder = FlashCardSetBuilder.new(deck, { 
          order: :random,
          num_cards: 2, 
          missed_filter: :last_missed,
          difficulty: "1"
        })

        flash_card_set = builder.generate_flash_cards
        
        expect(flash_card_set.size).to eq 2
        expect(possible_cards.map(&:id)).to include *(flash_card_set.map(&:id))
      end
    end

    context "with options that eliminate everything" do
      it "returns an empty set" do
        missed_cards_list = deck.flash_cards[0..1].map(&:id).map(&:to_s).join(",")
        deck_event = FactoryGirl.create(  
          :deck_event, 
          deck_id: deck.id,
          user_id: deck.user_id,
          missed_cards_list: missed_cards_list
        )
        builder = FlashCardSetBuilder.new(deck, { 
          order: :random,
          num_cards: 4, 
          missed_filter: :last_missed,
          difficulty: "2"
        })

        flash_card_set = builder.generate_flash_cards
        
        expect(flash_card_set).to be_empty
      end
    end
  end
  
end