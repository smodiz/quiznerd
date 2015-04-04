require 'spec_helper'

describe 'update flash card deck' do
  context 'with valid credentials' do
    before(:each) do
      @deck = FactoryGirl.create(:deck)
    end

    context 'and valid data' do
      before(:each) do
        post_data = {
          deck: {
            name: 'New name', status: 'Public', description: 'New description'
          }
        }
        token = @deck.user.authentication_token
        patch "/api/v1/decks/#{@deck.id}",
              post_data,
              'Authorization' => token_auth_header(token)
      end
      it_has_json_response
      it_has_status(200)
      it 'updates the deck' do
        @deck.reload
        expect(@deck.name).to eq 'New name'
        expect(@deck.status).to eq 'Public'
        expect(@deck.description).to eq 'New description'
      end
    end

    context 'with invalid data' do
      before(:each) do
        token = @deck.user.authentication_token
        patch "/api/v1/decks/#{@deck.id}",
              { deck: { name: '', status: '', description: '' } },
              'Authorization' => token_auth_header(token)
        @json_deck = JSON.parse(response.body, symbolize_names: true)[:decks]
      end
      it_has_json_response
      it_has_status(422)
      it 'returns error messages' do
        expected_errors = ["Name can't be blank",
                           "Description can't be blank",
                           "Status can't be blank",
                           'Status is not included in the list']
        expect(@json_deck).to match_array expected_errors
      end
    end
  end

  context 'with invalid credentials' do
    it 'returns an unauthorized 401 status code' do
      @deck = FactoryGirl.create(:deck)
      patch '/api/v1/decks/@deck.id',
            { deck: { name: '', status: '', description: '' } },
            'Authorization' => SecureRandom.hex(10)

      expect_status(401)
    end
  end
end
