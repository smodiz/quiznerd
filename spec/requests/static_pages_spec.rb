require 'spec_helper'

describe 'Static Pages' do
  subject { page }

  describe 'Home page' do
    before(:each) { visit root_path }
    let(:user)    { FactoryGirl.create(:user) }

    context 'when not signed in' do
      it { should have_content('Welcome to QuizNerd') }
      it { should have_title(full_title('')) }
      it { should_not have_title('| Home') }
      it { should have_link('Sign up now!') }
    end

    context 'when signed in' do
      before(:each) do
        valid_sign_in(user)
      end

      describe 'should show user specific home page' do
        it { should have_content('Quizzes Written') }
        it { should have_content('Quizzes Taken') }
        it { should have_link('New Quiz') }
        it { should have_link('Browse all Quizzes') }
        it { should have_content("You haven't taken any quizzes yet") }
        it { should have_content("You haven't written any quizzes yet") }
      end

      describe 'when I click the New Quiz link' do
        before do
          within('.home-page', match: :first) do
            click_link 'New Quiz'
          end
        end

        specify { expect(current_path).to eq(new_quiz_path) }
      end

      describe "when I click the 'Search for a Quiz' link" do
        before { click_link 'Browse all Quizzes' }
        specify { expect(current_path).to eq(search_path) }
      end

      describe 'when quiz has been written' do
        let(:quiz_written) do
          FactoryGirl.create(:quiz_with_questions, author: user)
        end
        before do
          quiz_written.save
          visit root_path
        end
        it 'should have link to written quiz' do
          expect(page).to have_link(quiz_written.name)
        end
      end

      describe 'when quiz has been taken' do
        let(:author) do
          FactoryGirl.create(:user)
        end
        let(:quiz_taken) do
          FactoryGirl.create(:quiz_with_questions, author: author)
        end
        let(:quiz_event) do
          FactoryGirl.create(:quiz_event, quiz: quiz_taken, user: user)
        end
        before do
          quiz_taken.save
          quiz_event.save
          visit root_path
        end
        it 'should have link to quiz that was taken' do
          expect(page).to have_link(quiz_taken.name)
        end
      end

      describe 'searching from the home page' do
        before(:each) do
          @quiz1 = FactoryGirl.create(:quiz, name: 'Looney Tunes')
          @quiz2 = FactoryGirl.create(:quiz, name: 'Looney Tones')
          within('form') do
            fill_in 'search', with: 'tones'
            click_button 'Search'
          end
        end

        it 'should show search results' do
          expect(current_path).to eq search_path
          expect(page).not_to have_content @quiz1.name
          expect(page).to have_content @quiz2.name
        end
      end
    end
  end

  describe 'About page' do
    before(:each) { visit about_path }
    it { should have_content('About') }
    it { should have_title(full_title('About')) }
  end

  describe 'Contact page' do
    before(:each) { visit contact_path }
    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end

  it 'should have the right links on the layout' do
    visit root_path
    click_link 'About'
    expect(page).to have_title(full_title('About'))
    click_link 'Contact'
    expect(page).to have_title(full_title('Contact'))
    click_link 'Home'
    expect(page).to have_title(full_title(''))
  end

  describe 'Click Logo' do
    before { visit contact_path }
    it 'should go to the home page' do
      click_link 'QuizNerd'
      expect(page).to have_title(full_title(''))
    end
  end
end
