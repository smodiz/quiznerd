require 'spec_helper'

describe Deck do 
  let(:deck) { FactoryGirl.create(:deck) }

  [:name, :status, :description, :flash_cards_count, :user_id].each do |attr|
    describe "when required field #{attr} is nil" do
      before(:each) do
        deck.send(attr.to_s + "=", nil)
        deck.valid?
      end

      it "is not valid" do
        expect(deck).not_to be_valid
      end

      it "has an error for required field missing" do
        expect(deck.errors).to include attr 
      end
    end
  end

  describe "when name is greater than 45 characters" do
    it "fails validation" do
      deck.name = "A"*46
      expect(deck).to_not be_valid
      expect(deck.errors).to include(:name)
      expect(deck.errors[:name].first).to match(/too long/)
    end
  end

  describe "when status is something other than a valid option " do
    it "fails validation" do
      deck.status = "Something"
      expect(deck).to_not be_valid
      expect(deck.errors).to include(:status)
    end
  end

  describe "flash_cards_count cache counter" do
    before(:each) do 
      @num_cards = deck.flash_cards_count
      @flash_card = FactoryGirl.create(:flash_card, deck_id: deck.id)
      deck.reload
    end

    it "is updated when flash cards for the deck are created" do
      expect(deck.flash_cards_count).to eq (@num_cards + 1)
    end
  end

  describe "#search" do
    let(:deck_1) { FactoryGirl.create(:deck, name: "Rails 4", status: "Public") }
    let(:deck_2) { FactoryGirl.create(:deck, name: "Java 4", status: "Private") }
    let(:deck_3) { FactoryGirl.create(:deck, name: "Rails Syntax", status: "Public") }
    let(:deck_4) { FactoryGirl.create(:deck, name: "Something", status: "Public") }

    before(:each) do
      deck_1; deck_2; deck_3; deck_4
    end

    describe "when given a search key word" do
      it "should return the matching records" do
        results = Deck.search_by("Rails")
        expect(results.size).to eq 2
        expect(results).to match_array([deck_1, deck_3])
        results = Deck.search_by("4")
        expect(results.size).to eq 1
        expect(results).to match_array([deck_1])
      end
    end

    describe "when not given a search key word" do
      it "should return all records" do
        expect(Deck.search_by("")).to match_array([deck_1, deck_3, deck_4])
      end
    end
  end

  describe "#seach_owned_by" do
    let(:user)    { FactoryGirl.create(:user) }
    let(:deck_1)  { FactoryGirl.create(:deck, name: "Rails 4", user: user, status: "Private") }
    let(:deck_2)  { FactoryGirl.create(:deck, name: "Java 4", user: user, status: "Public") }
    let(:deck_3)  { FactoryGirl.create(:deck, name: "Rails Syntax", user: user) }
    let(:deck_4)  { FactoryGirl.create(:deck, name: "Rails Validations") }
    
    before(:each) do
      user; deck_1; deck_2; deck_3; deck_4
    end

    describe "when given a search term" do
      it "returns the matching records for that user" do
        results = Deck.search_owned_by("Rails", user)
        expect(results.size).to eq 2
        expect(results).to match_array([deck_1, deck_3])
      end
    end

    describe "when not given a search term" do
      it "returns all the records for that user" do
        results = Deck.search_owned_by("", user)
        expect(results.size).to eq 3
        expect(results).to match_array([deck_1, deck_2, deck_3])
      end
    end
  end

  describe "new_for_user" do
    it "returns a new Deck with the correct user set" do
      user =  FactoryGirl.create(:user)
      deck = Deck.new_for_user(user)
      expect(deck.user).to eq user
    end
  end

  describe "with_flash_cards" do
    it "loads the deck and all associated cards" do
      deck = FactoryGirl.create(:deck)
      flash_card = FactoryGirl.create(:flash_card, deck_id: deck.id)
      result = Deck.with_flash_cards(deck.id)
      expect(result.flash_cards.size).to eq 1
    end
  end


end