require 'spec_helper'

describe "QuizEvents" do
 
  let(:quiz_author) { FactoryGirl.create(:user) }
  let(:quiz_taker)  { FactoryGirl.create(:user) }
  let(:quiz)        { FactoryGirl.create(:quiz_with_questions, author: quiz_author) }
  let(:quiz_event)  { FactoryGirl.create(:quiz_event, quiz: quiz, user: quiz_taker) }
  let(:new_quiz_url) { "/quiz_events/new?quiz_id=#{quiz.id}" }
  let(:question_type) { quiz_event.current_question.question_type }
  let(:number_of_questions) { quiz_event.number_of_questions }
  let(:correct_answer_ids) { quiz_event.current_question.correct_answer_ids }
  let(:correct_answer_text) do
    correct_text = []
    correct_answer_ids.each do |answer_id|
      correct_text << Answer.find(answer_id).content
    end
    correct_text
  end
  let(:incorrect_answer_text) do
    incorrect_id = quiz_event.current_question.incorrect_answer_ids[0]
    Answer.find(incorrect_id).content
  end
      

  before(:each) do
    valid_sign_in(quiz_taker)
    
  end

  subject { page }

  describe "shows quiz detail on the create page" do
    before { visit new_quiz_url }
    it { should have_content(quiz.name) }
    it { should have_button("Take This Quiz") }
  end

  describe "take the quiz" do
    before(:each) do
      visit new_quiz_url
      click_button "Take This Quiz"
    end

    describe "when I start the quiz" do
      it { should have_content("Question 1") }
      it { should have_button("Continue") }
      it { should have_link("Quit") }
    end

    context "when I answer the question" do
      it "should require an answer to be selected" do
        click_button "Continue"
        expect(page).to have_content("Answer cannot be blank") 
      end

      it "should display message for correctly answered question" do
        # MC-2 is multiple choice w/ multi selection, thus checkboxes,
        # otherwise it will be radio buttons
        if question_type == "MC-2"
          correct_answer_text.each do |answer_text| 
            check(answer_text)
          end
        else
          choose(correct_answer_text.to_s)
        end
        click_button "Continue"
        expect(page).to have_content "Correct!"
      end
      
      it "should display message for incorrectly answered question" do

        if question_type == "MC-2"
          check(incorrect_answer_text)
        else
          choose(incorrect_answer_text)
        end
        click_button "Continue"
        expect(page).to have_content "Incorrect!"
      end

      it "should not allow user to use back button to re-answer" do
        pending # I don't know how to simulate back button
      end
    end
  end

  describe "when I finish the quiz" do
    let(:small_quiz)  { FactoryGirl.create(:quiz_with_question, author: quiz_author) }
    let(:small_quiz_event)  { FactoryGirl.create(:quiz_event, quiz: small_quiz, user: quiz_taker) }
    let(:new_quiz_url) { "/quiz_events/new?quiz_id=#{small_quiz.id}" }
    let(:correct_answer_ids) { small_quiz_event.current_question.correct_answer_ids }
    let(:correct_answer_text) do
      correct_text = []
      correct_answer_ids.each do |answer_id|
        correct_text << Answer.find(answer_id).content
      end
      correct_text
    end
    let(:question_type) { small_quiz_event.current_question.question_type }

    before do
        visit new_quiz_url
        click_button "Take This Quiz"
        if question_type == "MC-2"
          correct_answer_text.each do |answer_text| 
            check(answer_text)
          end
        else
          choose(correct_answer_text.to_s)
        end
        click_button "Continue"
    end

    it "should display completion message" do
      expect(page).to have_content("You've completed the quiz")
    end

    it "should not allow user to go back once done" do
      pending # I don't know how to simulate back button
    end
  end

    describe "when user quits" do
      it "should remove the quiz_event from the database" do
        pending
      end
      it "should redirect the user to the home page" do
        pending
      end
    end
end
