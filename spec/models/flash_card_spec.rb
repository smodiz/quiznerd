require 'spec_helper'

describe FlashCard do 

  let(:flash_card) { FactoryGirl.create(:flash_card) }
  subject { flash_card }

  it { should be_valid }

  [:sequence, :front, :back, :difficulty, :deck_id].each do |attr|
    describe "when required field attr is nil" do 
      before(:each) do
        flash_card.send(attr.to_s + "=", nil)
        flash_card.valid?
      end
      it "is not valid" do
        expect(flash_card).to_not be_valid
      end
      it "has an error message for #{attr}" do
        expect(flash_card.errors).to include(attr)
      end
    end
  end

  describe "when sequence number is not unique" do
    before(:each) do
      @flash_2 = FactoryGirl.build(:flash_card, 
        sequence: flash_card.sequence,
        deck_id:  flash_card.deck_id)
      @flash_2.valid?
    end

    it "is not valid" do
      expect(@flash_2).not_to be_valid
    end

    it "has an error message" do
      expect(@flash_2.errors).to include(:sequence)
    end
  end

  describe "when difficulty is not in the list of valid options" do
    before(:each) do
      flash_card.difficulty = "Something"
      flash_card.valid?
    end

    it "is not valid" do
      expect(flash_card).not_to be_valid
    end
    it "has an error message" do
      expect(flash_card.errors).to include(:difficulty)
    end
  end

  [:front, :back].each do |attr|
    describe "#{attr} with large content" do
      it "is valid" do
        flash_card.send(attr.to_s + "=", "A"*400)
        expect(flash_card).to be_valid
      end
    end
  end

end