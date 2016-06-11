include ApplicationHelper

def valid_sign_in(user)
  visit new_user_session_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

# need this for those rare cases where I'm waiting
# on a server side change via ajax that does not
# change the dom on the browser, so can't just use
# Capybara's page.has_content? method, which automatically
# waits for things to complete.
def wait_until
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until yield
  end
end
