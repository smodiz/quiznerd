require 'spec_helper'

describe 'destroy flash card deck' do
  context 'with valid credentials' do
    context 'with valid record id' do
      before(:all) do
        @user   =   FactoryGirl.create(:user)
        @deck   =   FactoryGirl.create(:deck, user: @user)

        delete "/api/v1/decks/#{@deck.id}",
               {},
               http_headers(token: @user.authentication_token)
      end

      it_has_status(204)

      it 'removes the record' do
        expect { Deck.find(@deck.id) }.to raise_error
      end
    end

    context "with other users's record id" do
      it 'responds with status 404' do
        @user             =   FactoryGirl.create(:user)
        @other_user_deck  =   FactoryGirl.create(:deck)

        delete "/api/v1/decks/#{@other_user_deck.id}",
               {},
               http_headers(token: @user.authentication_token)

        expect_status(404)
      end
    end
  end

  context 'with invalid credentials' do
    it 'responds with access denied status 401' do
      @user       =   FactoryGirl.create(:user)
      @deck       =   FactoryGirl.create(:deck, user: @user)
      fake_token  =   SecureRandom.hex(10)

      delete "/api/v1/decks/#{@deck.id}",
             {},
             http_headers(token: fake_token)

      expect_status(401)
    end
  end
end
