require 'spec_helper'

describe "update flash card deck" do

  context "with valid credentials" do
    before(:each) do
      @deck = FactoryGirl.create(:deck)
    end

    context "and valid data" do
      before(:each) do
        patch   "/api/v1/decks/#{@deck.id}",
                { deck: {name: "New name", status: "Public", description: "New description" }},
                { 'Authorization' => token_auth_header(@deck.user.authentication_token) }
      end
      it "returns json content" do
        expect(response.content_type).to eq Mime::JSON
      end
      it "has a response status of 200" do
        expect(response.status).to eq 200
      end
      it "updates the deck" do
        @deck.reload
        expect(@deck.name).to eq "New name"
        expect(@deck.status).to eq "Public"
        expect(@deck.description).to eq "New description"
      end
    end 
    
    context "with invalid data" do
      before(:each) do
        patch   "/api/v1/decks/#{@deck.id}",
                { deck: {name: "", status: "", description: "" }},
                { 'Authorization' => token_auth_header(@deck.user.authentication_token) }
        @json_deck = JSON.parse(response.body, symbolize_names: true)[:decks]
      end
      it "returns json content" do
        expect(response.content_type).to eq Mime::JSON
      end
      it "returns a status of 422" do
        expect(response.status).to eq 422
      end
      it "returns error messages" do
        expected_errors = [ "Name can't be blank", 
                            "Description can't be blank", 
                            "Status can't be blank", 
                            "Status is not included in the list"]
        expect(@json_deck).to match_array expected_errors
      end
    end
  end

  context "with invalid credentials" do
    it "returns an unauthorized 401 status code" do
      @deck = FactoryGirl.create(:deck)
      patch   "/api/v1/decks/@deck.id",
              { deck: {name: "", status: "", description: "" }},
              { 'Authorization' => SecureRandom.hex(10) }

      expect(response.status).to eq 401
    end
  end

end