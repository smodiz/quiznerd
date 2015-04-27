include ApplicationHelper

def valid_sign_in(user)
  visit new_user_session_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

# Note: These methds cannot be named the same as the variable specified in the
# let methods that use them. See quiz_events_spec.rb

def correct_answer(question)
  # need all the correct answers
  answer_texts(question.correct_answer_ids)
end

def incorrect_answer(question)
  # just need one incorrect answer
  incorrect_id = question.incorrect_answer_ids[0]
  Answer.find(incorrect_id).content
end

def answer_texts(answer_ids)
  answer_texts = []
  answer_ids.each do |answer_id|
    answer_texts << Answer.find(answer_id).content
  end
  answer_texts
end

def answer_incorrectly
  if question_type == 'MC-2'
    check(incorrect_answer_text)
  else
    choose(incorrect_answer_text)
  end
end

def answer_correctly
  if question_type == 'MC-2'  # multiple answers, thus checkboxes
    correct_answer_text.each do |answer_text|
      check(answer_text)
    end
  else # single answer, thus radio button
    choose(correct_answer_text.to_s)
  end
end

def new_quiz_url_for(quiz_id)
  "/quiz_events/new?quiz_id=#{quiz_id}"
end


# need this for those rare cases where I'm waiting
# on a server side change via ajax that does not
# change the dom on the browser, so can't just use
# Capybara's page.has_content? method, which automatically
# waits for things to complete.
def wait_until
  Timeout.timeout(Capybara.default_wait_time) do
    loop until yield
  end
end


