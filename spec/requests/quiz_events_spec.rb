require 'spec_helper'

describe "Quiz Event Pages" do
 
  let(:quiz_author) { FactoryGirl.create(:user) }
  let(:quiz_taker)  { FactoryGirl.create(:user) }
  let(:quiz)        { FactoryGirl.create(:quiz, author: quiz_author) }
  let(:quiz_event)  { FactoryGirl.create(:quiz_event, quiz: quiz, user: quiz_taker) }
  let(:new_quiz_url)  { new_quiz_url_for(quiz.id) }

  before(:each) do
    quiz_event.question_id = quiz.questions.first.id
    quiz_event.answer_ids = quiz.questions.first.correct_answer_ids
    quiz_event.save!
    valid_sign_in(quiz_taker)
  end

  subject { page }

  
  describe "shows a quiz event on the index page" do
    before(:each) do
      visit quiz_events_path
    end
    
    it { should have_content("Quizzes Taken") }
    it { should have_content(quiz_event.quiz.name) }
    it { should have_content(quiz_event.total_correct) }
    it { should have_content(quiz_event.total_answered) }
  end

  describe "does not show other users quiz" do
    let(:user2) { FactoryGirl.create(:user) }
    let(:quiz_2) { FactoryGirl.create(:quiz, author: quiz_author) }
    let(:quiz_event_2)  { FactoryGirl.build(:quiz_event, 
      quiz: quiz_2, user: user2) }
    before(:each) do
      quiz_event_2.answer_ids = quiz_2.questions.first.correct_answer_ids
      quiz_event_2.question_id = quiz_2.questions.first.id
      quiz_event_2.save!
      visit quiz_events_path
    end
    it { should_not have_content(quiz_event_2.quiz.name) }
  end

  describe "shows quiz detail on the create page" do
    before { visit new_quiz_url }
    it { should have_content(quiz.name) }
    it { should have_button("Take This Quiz") }
  end

  describe "taking the quiz" do
    before(:each) do
      visit new_quiz_url
      click_button "Take This Quiz"
    end

    describe "when I start the quiz" do
      it { should have_content("Question 1") }
      it { should have_button("Continue") }
      it { should have_link("Quit") }
    end

    describe "when I answer the question" do
      let(:question_type) { quiz.questions.first.question_type }
      let(:incorrect_answer_text) { incorrect_answer(quiz.questions.first) }
      let(:correct_answer_text)   { correct_answer(quiz.questions.first) }  

      it "should require an answer to be selected" do
        click_button "Continue"
        expect(page).to have_content("Answer cannot be blank") 
      end

      context "correctly" do

        it "should display message for correctly answered question" do
          if question_type == "MC-2"  #multiple answers, thus checkboxes
            correct_answer_text.each do |answer_text| 
              check(answer_text)
            end
          else # single answer, thus radio button
            choose(correct_answer_text.to_s)
          end
          click_button "Continue"
          expect(page).to have_content "Correct!"
        end
      end
      
      context "incorrectly" do
        it "should display message for incorrectly answered question" do
          if question_type == "MC-2"
            check(incorrect_answer_text)
          else
            choose(incorrect_answer_text)
          end
          click_button "Continue"
          expect(page).to have_content "Incorrect!"
        end
      end
      
      it "should not allow user to use back button to re-answer" do
        pending "I don't know how to simulate back button yet"
        # ('window.history.back()')   # (needs js: true do)
        # OR? 
        # visit request.env['HTTP_REFERER']
        # expect(page).to have_content "Question cannot be answered more than once"
      end
    end
  end

  describe "when I finish the quiz" do

    before do
        visit new_quiz_url
        click_button "Take This Quiz"
        quiz.questions.each do |question|
          answer_text = question.answers.first.content
          check(answer_text)
          click_button "Continue"
        end
    end

    it "should display completion message" do
      expect(page).to have_content("You completed the quiz")
    end

    it "should not allow user to go back once done" do
      pending "I don't know how to simulate back button yet"
    end

  end

  describe "View completed quiz detail" do

    before do
      visit quiz_events_path
      click_link quiz_event.quiz.name
    end

    it { should have_content(quiz_event.quiz.name) }
    it { should have_content quiz_event.status }
    it { should have_link "Edit" }
    it { should have_button "Take This Quiz Again" }
  end

  describe "when user quits" do
    before do
      visit new_quiz_url
      click_button "Take This Quiz" 
      click_link "Quit" 
    end

    it "should redirect the user to the home page" do
      expect(current_path).to eq(root_path)
    end
    it "should remove the quiz_event from the database" do
      within ('#quizzes') do
        expect(page).to_not have_link quiz.name
      end
    end
  end

end
