require 'spec_helper'

describe 'create flash card deck' do
  context 'with valid data' do
    describe 'successfully creates flash deck' do
      before(:all) do
        user = FactoryGirl.create(:user)
        @deck = FactoryGirl.build(:deck, user: user)
        token = user.authentication_token
        post '/api/v1/decks', @deck.to_json, http_headers(token: token)

        @response_deck = JSON.parse(response.body, symbolize_names: true)[:deck]
      end

      it_has_json_response

      it_has_status(201)

      it 'has the correct location' do
        expected_loc = api_v1_deck_url(@response_deck[:id])
        expect(response.location).to eq expected_loc
      end

      it 'has the correct fields' do
        expect(@response_deck[:id]).not_to be_nil
        expect(@response_deck[:user_id]).to eq @deck.user.id
        expect(@response_deck[:name]).to eq @deck.name
        expect(@response_deck[:description]).to eq @deck.description
        expect(@response_deck[:status]).to eq @deck.status
      end
    end
  end

  context 'with invalid data' do
    describe 'does not create deck' do
      before(:all) do
        user = FactoryGirl.create(:user)
        @deck = Deck.new
        token = user.authentication_token
        post '/api/v1/decks', @deck.to_json, http_headers(token: token)
        @response_deck = JSON.parse(response.body, symbolize_names: true)
      end

      it_has_status(422)

      it 'returns an error message' do
        expected_errors = ["Name can't be blank",
                           "Description can't be blank",
                           "Status can't be blank",
                           'Status is not included in the list']
        expect(@response_deck[:decks]).to match_array expected_errors
      end
    end
  end
end
