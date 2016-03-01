describe 'create flash card' do
  context 'with valid data' do
    describe 'successfully creates flash card' do
      before(:all) do
        user = FactoryGirl.create(:user)
        @deck = FactoryGirl.create(:deck, user: user)
        @flash_card = FactoryGirl.build(:flash_card, deck_id: @deck.id)
        token = user.authentication_token
        post '/api/v1/flash_cards',
             @flash_card.to_json,
             http_headers(token: token)

        @response_card = JSON.parse(
          response.body,
          symbolize_names: true)[:flash_card]
      end

      it_has_json_response

      it_has_status(201)

      it 'has the correct location' do
        expected_loc = api_v1_flash_card_url(@response_card[:id])
        expect(response.location).to eq expected_loc
      end

      it 'has the correct fields' do
        expect(@response_card[:id]).not_to be_nil
        expect(@response_card[:front]).to eq @flash_card.front
        expect(@response_card[:back]).to eq @flash_card.back
        expect(@response_card[:deck_id]).to eq @deck.id
      end
    end
  end

  context 'with invalid data' do
    describe 'does not create deck' do
      before(:each) do
        user = FactoryGirl.create(:user)
        @deck = FactoryGirl.create(:deck, user: user)
        @flash_card = @deck.flash_cards.build.to_json
        token = user.authentication_token
        post '/api/v1/flash_cards', @flash_card, http_headers(token: token)

        @response_card = JSON.parse(
          response.body,
          symbolize_names: true)[:flash_cards]
      end

      it_has_status(422)

      it 'returns an error message' do
        expected_errors = ["Front can't be blank", "Back can't be blank"]
        expect(@response_card).to match_array expected_errors
      end
    end
  end
end
