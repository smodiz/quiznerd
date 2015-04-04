require 'spec_helper'

describe 'Flash Deck Pages' do
  let(:deck) { FactoryGirl.create(:deck) }

  subject { page }

  before(:each) do
    deck
    valid_sign_in(deck.user)
  end

  describe 'the menu' do
    it 'shows the flash deck index link' do
      visit root_path
      expect(page).to have_link('My Flash Decks')
      click_link 'My Flash Decks'
      expect(current_path).to eq(decks_path)
    end
    it 'shows a link for creating a new deck' do
      visit root_path
      expect(page).to have_link('New Flash Deck')
      click_link 'New Flash Deck'
      expect(current_path).to eq(new_deck_path)
    end
  end

  describe 'index page' do
    before(:each) do
      @another_deck = FactoryGirl.create(:deck)
      visit decks_path
    end

    it { should have_css('div', text: 'Flash Decks') }
    it { should have_content(deck.name) }
    it { should have_link('play-link') }
    it { should have_link('delete-link') }
    it { should have_link('New Flash Deck') }

    it 'does not show other users decks' do
      expect(page).not_to have_content(@another_deck.name)
    end
  end

  describe 'creating a new flash deck' do
    it 'creates a new deck' do
      decks_count = Deck.all.count
      visit decks_path
      within('.page-actions') do
        click_link 'New Flash Deck'
      end
      fill_in 'Name', with: 'Fun With Rails'
      fill_in 'Description', with: 'Test your knowledge of fun.'
      select 'Private', from: 'Status'
      click_button 'Create'

      expect(page).to have_content('Deck was successfully saved')
      expect(page).to have_css('.section-header', text: 'Fun With Rails')
      expect(Deck.all.count).to eq(decks_count + 1)
    end
  end

  describe 'show flash deck'  do
    it 'shows the deck' do
      visit decks_path
      click_link deck.name
      expect(page).to have_css('.section-header', text: deck.name)
      expect(page).to have_css('.breadcrumb li', text: 'My Flash Decks')
      expect(page).to have_css('.breadcrumb li', text: 'Show Flash Deck')
      expect(page).to have_content(deck.status)
      expect(page).to have_content(deck.description)
    end
    it 'deletes the deck when delete button is clicked' do
      visit deck_path(deck)
      click_link 'Delete'
      expect(Deck.where(id: deck.id)).to be_empty
      expect(page).to have_content('Deck was successfully destroyed')
      expect(page).to have_css('div', text: 'Flash Decks')
      expect(current_path).to eq(decks_path)
    end
    it 'shows the edit page when edit button is clicked' do
      visit deck_path(deck)
      click_link 'Edit'
      expect(current_path).to eq(edit_deck_path(deck))
    end
  end

  describe 'delete flash deck' do
    before(:each) do
      visit decks_path
    end

    it 'deletes a deck when the link is clicked' do
      click_link 'delete-link'
      expect(page).not_to have_content(deck.name)
      expect(Deck.where(id: deck.id)).to be_empty
      expect(current_path).to eq(decks_path)
    end
  end

  describe 'update flash deck' do
    before(:each) do
      visit decks_path
      click_link deck.name
      click_link 'Edit'
    end

    it 'updates the deck' do
      expect(page).to have_css('.section-header', text: 'Edit Flash Deck')
      expect(page).to have_css('.breadcrumb li', text: 'My Flash Decks')
      fill_in 'Name', with: 'New name'
      click_button 'Update Deck'

      expect(page).to have_content('Deck was successfully saved')
      expect(current_path).to eq(deck_path(deck))
    end
    it 'returns to the show page when cancel is clicked' do
      click_link 'Cancel'
      expect(current_path).to eq(deck_path(deck))
    end
  end

  describe 'search for a deck' do
    before(:each) do
      @dk1 = FactoryGirl.create(:deck, user: deck.user, tag_list: 'rails, api')
      @dk2 = FactoryGirl.create(:deck, user: deck.user, tag_list: 'api, arrays')
      @dk3 =
        FactoryGirl.create(:deck, user: deck.user, tag_list: 'rails, arrays')
      visit decks_path
    end
    context 'by search term' do
      it 'returns only the matching records for the user' do
        fill_in 'search', with: @dk1.name
        click_button 'Search'
        expect(page).to have_content @dk1.name
        expect(page).not_to have_content @dk2.name
      end
    end
    context 'by tag' do
      it 'returns only the matching records' do
        click_link 'rails'
        expect(page).to have_content @dk1.name
        expect(page).to have_content @dk3.name
        expect(page).to_not have_content @dk2.name
      end
    end
  end

  describe 'as wrong user' do
    before(:each) do
      other_user = FactoryGirl.create(:user)
      @deck = FactoryGirl.create(:deck, user: other_user)
      @deck
    end

    describe 'submit a GET request to Decks#edit action' do
      before { get edit_deck_path(@deck) }
      specify { expect(current_path).to eq root_path }
    end
    describe 'submit a PATCH request to Decks#edit action' do
      before { patch deck_path(@deck) }
      specify { expect(current_path).to eq root_path }
    end
    describe 'submit a DELETE request to Decks#edit action' do
      before { delete deck_path(@deck) }
      specify { expect(current_path).to eq root_path }
    end
  end
end
