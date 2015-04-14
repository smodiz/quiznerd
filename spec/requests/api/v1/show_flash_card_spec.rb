require 'spec_helper'

describe 'list all flash cards for a deck' do
  before(:all) do
    deck = FactoryGirl.create(:deck_with_flash_cards)
    @flash_card = deck.flash_cards.first
    get "/api/v1/flash_cards/#{@flash_card.id}",
        {},
        http_headers(token: deck.user.authentication_token)
  end

  it_has_status(200)

  it_has_json_response

  it 'returns a flash card' do
    flash_card = JSON.parse(response.body, symbolize_names: true)[:flash_card]
    expect(flash_card[:id]).to eq @flash_card.id
    expect(flash_card[:front]).to eq @flash_card.front
    expect(flash_card[:back]).to eq @flash_card.back
    expect(flash_card[:sequence]).to eq @flash_card.sequence
    expect(flash_card[:difficulty]).to eq @flash_card.difficulty
  end
end
