require 'spec_helper'

describe 'Quiz Event Pages' do
  let(:quiz_event)  { FactoryGirl.create(:small_quiz_event) }
  let(:new_quiz_url)  { new_quiz_url_for(quiz_event.quiz.id) }

  before(:each) do
    valid_sign_in(quiz_event.user)
  end

  subject { page }

  describe 'shows a quiz event on the index page' do
    before(:each) do
      visit quiz_events_path
    end

    it { should have_content('Quizzes Taken') }
    it { should have_content(quiz_event.quiz.name) }
    it { should have_content(quiz_event.total_correct) }
    it { should have_content(quiz_event.total_answered) }
  end

  describe 'does not show other users quiz event' do
    let(:quiz_event_2)  { FactoryGirl.create(:small_quiz_event) }
    before(:each) do
      visit quiz_events_path
    end
    it { should_not have_content(quiz_event_2.quiz.name) }
  end

  describe 'shows quiz detail on the create page' do
    before { visit new_quiz_url }
    it { should have_content(quiz_event.quiz.name) }
    it { should have_link('Take This Quiz') }
  end

  describe 'taking the quiz' do
    before(:each) do
      visit new_quiz_url
      click_link 'Take This Quiz'
    end

    describe 'when I start the quiz' do
      it { should have_content('Question 1') }
      it { should have_button('Continue') }
      it { should have_link('Quit') }

      context 'author deletes the quiz after I start taking it' do
        it 'redirects me to the home page with a message' do
          quiz_event.quiz.destroy!
          click_button 'Continue'
          expect(current_path).to eq(root_path)
          expect(page).to have_content 'author must have deleted that quiz'
        end
      end
    end

    describe 'when I answer the question', js: true do
      let(:question_type) do
        quiz_event.quiz.questions.first.question_type
      end
      let(:incorrect_answer_text) do
        incorrect_answer(quiz_event.quiz.questions.first)
      end
      let(:correct_answer_text) do
        correct_answer(quiz_event.quiz.questions.first)
      end

      it 'should require an answer to be selected' do
        click_button 'Continue'
        expect(page).to have_content('Answer ids can\'t be blank')
      end

      context 'correctly' do
        it 'should display message for correctly answered question' do
          answer_correctly
          click_button 'Continue'
          expect(page).to have_content 'Correct!'
        end
      end

      context 'incorrectly' do
        before(:each) do
          answer_incorrectly
          click_button 'Continue'
        end

        it 'should display message for incorrectly answered question' do
          expect(page).to have_content 'Incorrect!'
        end

        it 'should not allow user to use back button to re-answer' do
          expect(page).to have_content 'Incorrect!'
          page.evaluate_script('window.history.back()')
          answer_correctly
          click_button 'Continue'
          expect(page).to have_content 'Correct'
        end
      end
    end
  end

  describe 'when I finish the quiz', js: true do
    before do
      visit new_quiz_url
      click_link 'Take This Quiz'
      quiz_event.quiz.questions.each do |question|
        answer_text = question.answers.first.content
        check(answer_text)
        click_button 'Continue'
      end
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
      before do
        visit quiz_events_path
        click_link quiz_event.quiz.name
      end

      it { should have_content(quiz_event.quiz.name) }
      it { should have_content quiz_event.status }
      it { should have_link 'Edit' }
      it 'should have take again link' do
        expect(page).to have_link 'Take This Quiz Again'
      end
    end

    context 'after display show page but before clicking Take This Quiz link' do
      it 'routes me to the index page if the author deletes the quiz' do
        visit new_quiz_event_path(quiz_id: quiz_event.quiz.id)
        quiz_event.quiz.destroy!
        click_link 'Take This Quiz'
        expect(current_path).to eq(root_path)
      end
    end

    context 'when quiz still exists but is not public any more' do
      before do
        quiz_event.quiz.toggle_publish
        quiz_event.quiz.save!
        visit quiz_events_path
        click_link quiz_event.quiz.name
      end

      it { should have_content(quiz_event.quiz.name) }
      it { should have_content quiz_event.status }
      it { should have_link 'Edit' }
      it 'should not have take again link' do
        expect(page).not_to have_link 'Take This Quiz Again'
      end
    end
  end

  describe 'when user quits' do
    before do
      visit new_quiz_url
      click_link 'Take This Quiz'
      click_link 'Quit'
    end

    it 'should redirect the user to the home page' do
      expect(current_path).to eq(root_path)
    end
    it 'should remove the quiz_event from the database' do
      within('#quizzes') do
        expect(page).to_not have_link quiz_event.quiz.name
      end
    end
  end
end
