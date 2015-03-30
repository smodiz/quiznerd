require 'spec_helper'

describe "create flash card deck" do 

  context "with valid data" do
    describe "successfully creates flash deck" do
      before(:all) do
        user = FactoryGirl.create(:user)
        @deck = FactoryGirl.build(:deck, user: user)
        post '/api/v1/decks', @deck.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => token_auth_header(user.authentication_token) 
        }
        @response_deck = JSON.parse(response.body, symbolize_names: true)[:deck]
      end

      it "has json content" do
        expect(response.content_type).to eq Mime::JSON
      end

      it "returns the correct status" do
        expect(response.status).to eq 201
      end

      it "has the correct location" do
        expected_loc = api_v1_deck_url(@response_deck[:id])
        expect(response.location).to eq expected_loc
      end

      it "has the correct fields" do
        expect(@response_deck[:id]).not_to be_nil
        expect(@response_deck[:user_id]).to eq @deck.user.id
        expect(@response_deck[:name]).to eq @deck.name
        expect(@response_deck[:description]).to eq @deck.description
        expect(@response_deck[:status]).to eq @deck.status
      end
    end
  end

  context "with invalid data" do
    describe "does not create deck" do
      before(:all) do
        user = FactoryGirl.create(:user)
        @deck = Deck.new
        post '/api/v1/decks', @deck.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => token_auth_header(user.authentication_token) 
        }
        @response = JSON.parse(response.body, symbolize_names: true)
      end
      it "returns a 422 status" do
        expect(response.status).to eq 422
      end
      it "returns an error message" do
        expected_errors = [ "Name can't be blank", 
                            "Description can't be blank", 
                            "User can't be blank", 
                            "Status can't be blank", 
                            "Status is not included in the list"]
        expect(@response[:decks]).to match_array expected_errors
      end
    end
  end


end