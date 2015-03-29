require 'spec_helper'

describe "show a flash card deck" do  

  before(:each) do
    @deck = FactoryGirl.create(:deck_with_flash_cards)
    puts "User auth_token is #{@deck.user.authentication_token}"
    get "/api/decks/#{@deck.id}", 
          { 'auth_token' => @deck.user.authentication_token },  
          { }
  end

  it "returns a good status" do
    expect(response.status).to eq 200
  end

  it "has json content" do
    expect(response.content_type).to eq Mime::JSON
  end

  it "returns the flash card deck" do
    json_deck = JSON.parse(response.body, symbolize_names: true)[:deck]
    expect(json_deck[:id]).to eq @deck.id
    expect(json_deck[:name]).to eq @deck.name
    expect(json_deck[:description]).to eq @deck.description
    expect(json_deck[:flash_cards_count]).to eq 5
  end

  it "returns the associated flash cards" do
    json_deck   = JSON.parse(response.body, symbolize_names: true)[:deck]
    json_cards  = json_deck[:flash_cards]
    first       = json_cards.first
    last        = json_cards.last
    
    expect(json_cards.size).to eq 5
    validate_flash_card(@deck.flash_cards.first, first)
    validate_flash_card(@deck.flash_cards.last, last)
  end  


  def validate_flash_card(flash_card, json_flash_card)
    expect(json_flash_card[:id]).to eq flash_card.id
    expect(json_flash_card[:front]).to eq flash_card.front
    expect(json_flash_card[:back]).to eq flash_card.back
    expect(json_flash_card[:sequence]).to eq flash_card.sequence
    expect(json_flash_card[:difficulty]).to eq flash_card.difficulty
  end
end



