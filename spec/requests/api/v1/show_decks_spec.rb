require 'spec_helper'

describe "list all decks for a user" do

  before(:all) do
    user        = FactoryGirl.create(:user)
    @deck1      = FactoryGirl.create(:deck_with_two_cards, user: user)
    @deck2      = FactoryGirl.create(:deck_with_two_cards, user: user)
    other_user  = FactoryGirl.create(:user)
    @other_deck = FactoryGirl.create(:deck_with_two_cards, user: other_user)

    get '/api/v1/decks', 
        {}, 
        { 'Authorization' => token_auth_header(user.authentication_token) }

    @decks = JSON.parse(response.body, symbolize_names: true)[:decks]    
  end

  it_has_status(200)

  it_has_json_response

  it "lists all decks for a given user" do
    expect(@decks.length).to eq 2
    expect(@decks.map {|d| d[:id] }).to match_array [@deck1.id, @deck2.id]
  end 

  it "does not list other users's decks" do
    expect(@decks.map { |d| d[:id] }).not_to include @other_deck.id
  end
end