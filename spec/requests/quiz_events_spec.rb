require 'spec_helper'

describe 'Quiz Event Pages' do

  before(:each) do
    valid_sign_in(user)
  end

  subject { page }

  describe 'shows a quiz event on the index page' do
    it 'displays the proper fields' do
      quiz_event = FactoryGirl.create(:small_quiz_event, user: user)

      visit quiz_events_path

      expect(page).to have_content('Quizzes Taken')
      expect(page).to have_content(quiz_event.quiz.name)
      expect(page).to have_content(quiz_event.total_correct)
      expect(page).to have_content(quiz_event.total_answered)
    end

    it 'does not show other users quiz events' do
      other_user_quiz_event = FactoryGirl.create(:small_quiz_event)

      visit quiz_events_path

      expect(page).not_to have_content(other_user_quiz_event.quiz.name)
    end
  end

  describe 'shows quiz detail on the create page' do
    it 'displays the proper fields' do
      quiz = FactoryGirl.create(:quiz_with_questions)

      visit new_quiz_url_for(quiz.id)

      expect(page).to have_content(quiz.name)
      expect(page).to have_link('Take This Quiz')
    end
  end

  describe 'when taking the quiz (creating a new quiz event)' do
    # before(:each) do
    #   @quiz = FactoryGirl.create(:quiz_with_questions)
    #   visit new_quiz_url_for(@quiz.id)
    #   click_link 'Take This Quiz'
    # end

    describe 'when I start the quiz' do
      it 'displays the proper fields on the start page' do
        start_quiz
        expect(page).to have_content('Question 1')
        expect(page).to have_button('Continue')
        expect(page).to have_link('Quit')
      end

      context 'author deletes the quiz after I start taking it' do
        it 'redirects me to the home page with a message' do
          quiz = start_quiz
          quiz.destroy!

          click_button 'Continue'

          expect(current_path).to eq(root_path)
          expect(page).to have_content 'author must have deleted that quiz'
        end
      end
    end

    describe 'when I answer the question', js: true do
      # let(:question) do
      #   @quiz.questions.first
      # end

      it 'should require an answer to be selected' do
        start_quiz
        click_button 'Continue'
        expect(page).to have_content('Answer ids can\'t be blank')
      end

      context 'correctly' do
        it 'should display message for correctly answered question' do
          quiz = start_quiz

          answer_correctly(quiz.questions.first)
          click_button 'Continue'

          expect(page).to have_content 'Correct!'
        end
      end

      context 'incorrectly' do
        it 'should display message for incorrectly answered question' do
          quiz = start_quiz

          answer_incorrectly(quiz.questions.first)
          click_button 'Continue'

          expect(page).to have_content 'Incorrect!'
        end

        it 'should not allow user to use back button to re-answer' do
          quiz = start_quiz

          answer_incorrectly(quiz.questions.first)
          click_button 'Continue'

          page.evaluate_script('window.history.back()')
          answer_correctly(quiz.questions.first)
          click_button 'Continue'

          expect(page).to have_content 'Correct'
        end
      end
    end
  end

  describe 'when I finish the quiz', js: true do
    before do
      take_quiz
    end

    it 'should display completion message' do
      expect(page).to have_content('You have completed the quiz')
    end

    it 'should not allow user to go back once done' do
      page.evaluate_script('window.history.back()')
      expect(page).to \
        have_content('Cannot re-answer questions. Quiz already completed.')
    end
  end

  describe 'Show Quiz Event' do
    context 'when quiz still exists and is public' do
      it 'shows the "Take Again" link' do
        quiz_event = FactoryGirl.create(:small_quiz_event, user: user)
        visit quiz_events_path

        click_link quiz_event.quiz.name

        expect(page).to have_content(quiz_event.quiz.name)
        expect(page).to have_content quiz_event.status
        expect(page).to have_link 'Edit'
        expect(page).to have_link 'Take This Quiz Again'
      end
    end

    context 'after display show page but before clicking Take This Quiz link' do
      it 'routes me to the index page if the author deletes the quiz' do
        quiz_event = FactoryGirl.create(:small_quiz_event, user: user)
        visit new_quiz_event_path(quiz_id: quiz_event.quiz.id)
        quiz_event.quiz.destroy!

        click_link 'Take This Quiz'

        expect(current_path).to eq(root_path)
      end
    end

    context 'when quiz still exists but is not public any more' do
      it 'does not show the "Take Again" link' do
        @quiz_event = FactoryGirl.create(:small_quiz_event, user: user)
        @quiz_event.quiz.toggle_publish
        @quiz_event.quiz.save!

        visit quiz_events_path
        click_link @quiz_event.quiz.name

        expect(page).to have_content(@quiz_event.quiz.name)
        expect(page).to have_content @quiz_event.status
        expect(page).to have_link 'Edit'
        expect(page).not_to have_link 'Take This Quiz Again'
      end
    end
  end

  describe 'when user quits' do
    it 'should redirect the user to the home page' do
      quiz = FactoryGirl.create(:quiz_with_questions)

      visit new_quiz_url_for(quiz.id)
      click_link 'Take This Quiz'
      click_link 'Quit'

      expect(current_path).to eq(root_path)
      within('#quizzes') do
        expect(page).to_not have_link quiz.name
      end
    end
  end

  describe 'user resets quiz events history' do
    it 'should delete quiz events and display index page w/o any quiz events' do
      quiz_event = FactoryGirl.create(:quiz_event, user: user)

      visit quiz_events_path
      click_link('Reset History')

      expect(page).to have_content('History successfully cleared!')
      expect(page).not_to have_content(quiz_event.quiz.name)
      expect(QuizEvent.all.count).to eq 0
    end

    it 'should not show quiz events on the dashboard page' do
      quiz_event = FactoryGirl.create(:quiz_event, user: user)

      visit quiz_events_path
      click_link('Reset History')
      visit root_path

      expect(page).not_to have_content(quiz_event.quiz.name)
    end
  end
end

# ---------------  helper methods --------------

def user
  @user ||= FactoryGirl.create(:user)
end

def answer_incorrectly(question)
  incorrect_answer_text = incorrect_answer(question)
  if question.question_type == 'MC-2'
    check(incorrect_answer_text) # checkbox
  else
    choose(incorrect_answer_text) # radio button
  end
end

def answer_correctly(question)
  correct_answer_text = correct_answer(question)
  if question.question_type == 'MC-2'
    correct_answer_text.each do |answer_text|
      check(answer_text) # checkbox
    end
  else
    choose(correct_answer_text.to_s) # radio button
  end
end

def correct_answer(question)
  # need ALL the correct answers
  answer_texts(question.correct_answer_ids)
end

def incorrect_answer(question)
  # just need ONE incorrect answer
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

def new_quiz_url_for(quiz_id)
  "/quiz_events/new?quiz_id=#{quiz_id}"
end

def start_quiz
  quiz = FactoryGirl.create(:quiz_with_questions)
  visit new_quiz_url_for(quiz.id)
  click_link 'Take This Quiz'
  quiz
end

def take_quiz
  quiz = FactoryGirl.create(:quiz_with_questions)
  new_quiz_url = new_quiz_url_for(quiz.id)

  visit new_quiz_url
  click_link 'Take This Quiz'
  quiz.questions.each do |question|
    answer_text = question.answers.first.content
    check(answer_text)
    click_button 'Continue'
  end
end
