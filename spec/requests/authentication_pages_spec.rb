require 'spec_helper'

#
# Note: I am using devise for authentication. It feels redundant to have
# these tests, since devise should also have these tests or something
# similar.
#
# I'm providing these anyway because:
#
#   1. if I want to replace devise with my own authentication in
#   the future, these tests will already be here.
#
#   2. as devise gets updated something could break related to my
#   specific environment and my tests will catch that.
#
# However, these tests are not as all-encompassing as they would be if
# I had written the authentication myself. They are just enough to let
# me know if things have gone horribly wrong.
#

describe 'Authentication Pages' do
  subject { page }

  shared_examples_for 'signed in user' do
    it { should have_link('Sign out') }
    it { should have_link('Edit profile') }
    it { should_not have_link('Sign in') }
  end

  shared_examples_for 'non-signed in user' do
    it { should_not have_link('Sign out') }
    it { should_not have_link('Edit profile') }
    it { should have_link('Sign in') }
  end

  describe 'Sign up' do
    before(:each) { visit new_user_registration_path }

    describe 'Sign up page' do
      it { should have_link('Already a member? Sign in') }
      it_behaves_like 'non-signed in user'
    end

    context 'with valid crendentials' do
      before do
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'foobarbaz'
        fill_in 'Confirm', with: 'foobarbaz'
        click_button 'Sign up'
      end

      it { should have_content('Welcome! You have signed up successfully') }
      it_behaves_like 'signed in user'
    end

    context 'with invalid crendentials' do
      before do
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: ''
        fill_in 'Confirm', with: ''
        click_button 'Sign up'
      end

      it { should have_content("can't be blank") }
      it { should have_content('Sign up') }
      it_behaves_like 'non-signed in user'
    end
  end

  describe 'Sign in' do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) { visit new_user_session_path }

    describe 'Sign in page' do
      it { should have_link('Sign up') }
      it { should have_link('Forgot your password?') }
      it_behaves_like 'non-signed in user'
    end

    context 'with valid crendentials' do
      before(:each) do
        valid_sign_in(user)
      end

      it { should have_content('Signed in successfully') }
      it_behaves_like 'signed in user'

      describe 'followed by sign out' do
        before { click_link('Sign out') }

        it { should have_content('Signed out successfully') }
        it { should have_content('Welcome to QuizNerd') }
        it_behaves_like 'non-signed in user'
      end
    end

    context 'with invalid crendentials' do
      before(:each) do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'invalid_passwd'
        click_button 'Sign in'
      end
      it { should have_content('Invalid email or password') }
      it { should have_content('Sign in') }
      it_behaves_like 'non-signed in user'
    end
  end

  describe 'Forgot password' do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      visit new_user_session_path
      click_link('Forgot your password?')
    end

    it { should have_selector('h3', 'Forgot your password?') }
    it { should have_link('Sign up') }
    it { should have_link('Already a member? Sign in') }

    context 'with valid email' do
      before do
        fill_in 'Email', with: user.email
        ActionMailer::Base.deliveries.clear
        click_button('Send me reset password instructions')
      end

      it { should have_content('You will receive an email') }
      it { should have_selector('h3', 'Sign in') }
      it 'should send the email' do
        expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
      end
    end

    context 'with invalid email' do
      before do
        fill_in 'Email', with: 'does_not_exist@noway.com'
        click_button('Send me reset password instructions')
      end
      it { should have_content('not found') }
      it { should have_selector('h3', 'Forgot your password?') }
    end
  end

  describe 'Cancel account' do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      valid_sign_in(user)
      click_link 'Edit profile'
      click_link 'Cancel my account'
    end
    it { should have_content('Your account was successfully cancelled') }
    it_behaves_like 'non-signed in user'
  end

  describe 'edit user' do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      valid_sign_in(user)
      visit edit_user_registration_path
    end

    describe 'edit user page' do
      it { should have_selector('h3', 'Edit User') }
      it { should have_link('Back') }
      it { should have_selector('input', user.email) }
      it { should have_link('Cancel my account') }
      it { should have_link('Get New Token') }
      it { should have_css('.auth-token', text: user.authentication_token) }
    end

    describe 'change password' do
      context 'with valid current password' do
        before do
          fill_in 'user_password', with: 'new_password'
          fill_in 'user_password_confirmation', with: 'new_password'
          fill_in 'user_current_password', with: user.password
          click_button('Update')
        end
        it { should have_content('You updated your account successfully') }
      end

      context 'with invalid current password' do
        before do
          fill_in 'user_password', with: 'new_password'
          fill_in 'user_password_confirmation', with: 'new_password'
          fill_in 'user_current_password', with: 'invalid_really'
          click_button('Update')
        end
        it { should have_content('is invalid') }
      end
    end

    describe 'change email' do
      context 'valid new email' do
        before do
          fill_in 'Email', with: 'valid@example.com'
          fill_in 'user_current_password', with: user.password
          click_button('Update')
        end
        it { should have_content('You updated your account successfully') }
      end

      context 'duplicate new email' do
        let(:user2) { FactoryGirl.create(:user) }
        before do
          fill_in 'Email', with: user2.email
          click_button('Update')
        end
        it { should have_content('has already been taken') }
        it { should have_selector('h3', 'Edit User') }
      end

      context 'invalid email format' do
        before do
          fill_in 'Email', with: 'me@me'
          click_button('Update')
        end
        it { should have_content('is invalid') }
        it { should have_selector('h3', 'Edit User') }
      end
    end

    describe 'reset authentication token', js: true do
      it 'displays a new token on the page' do
        orig_token = user.authentication_token

        click_link 'Get New Token'

        wait_until { user.reload.authentication_token != orig_token }
        new_token = user.reload.authentication_token
        expect(new_token).not_to eq orig_token
        expect(page).to have_content(new_token)
      end
    end
  end
end
