require 'spec_helper'

describe "QuizEvents" do
 
  let(:quiz_author) { FactoryGirl.create(:user) }
  let(:quiz_taker)  { FactoryGirl.create(:user) }
  let(:quiz)        { FactoryGirl.create(:quiz_with_questions, author: quiz_author) }
  let(:quiz_event)  { FactoryGirl.create(:quiz_event, quiz: quiz, user: quiz_taker) }
  let(:new_quiz_url)          { new_quiz_url_for(quiz.id) }
  let(:question_type)         { quiz_event.current_question.question_type }
  let(:number_of_questions)   { quiz_event.number_of_questions }
  let(:correct_answer_text)   { correct_answer_texts(quiz_event) }
  let(:incorrect_answer_text) { incorrect_answer_texts(quiz_event) }

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
    let(:small_quiz)            { FactoryGirl.create(:quiz_with_question, author: quiz_author) }
    let(:small_quiz_event)      { FactoryGirl.create(:quiz_event, quiz: small_quiz, user: quiz_taker) }
    let(:new_quiz_url)          { new_quiz_url_for(small_quiz.id) }
    let(:correct_answer_text)   { correct_answer_texts(small_quiz_event) }
    let(:question_type)         { small_quiz_event.current_question.question_type }

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
    before do
      visit new_quiz_url
      click_button "Take This Quiz" 
      click_link "Quit" 
    end

    it "should redirect the user to the home page" do
      expect(current_path).to eq(root_path)
    end
    it "should remove the quiz_event from the database" do
      expect(page).to_not have_link quiz.name
    end
  end
end