require 'spec_helper'

describe 'Questions' do
  let(:quiz) { FactoryGirl.create(:quiz) }
  let(:question) { FactoryGirl.create(:question, quiz: quiz) }

  subject { page }

  before(:each) { valid_sign_in(quiz.author) }

  describe 'when I visit the add new question page' do
    before(:each) do
      visit quiz_path(quiz)
      click_link 'Add Question'
    end

    it { should have_content('New question') }
    specify { expect(current_path).to eq(new_question_path) }
    it { should have_button 'Create Question' }
  end

  describe 'when I add a question' do
    before(:each) do
      visit quiz_path(quiz)
      click_link 'Add Question'
      fill_in 'Question', with: question.content
      fill_in 'Remarks', with: question.remarks
      select question.question_type_description, from: 'Question type'
      fill_in 'question_answers_attributes_0_content', with: 'Some answer 1'
      fill_in 'question_answers_attributes_1_content', with: 'Some answer 2'
      fill_in 'question_answers_attributes_2_content', with: 'Some answer 3'
      fill_in 'question_answers_attributes_3_content', with: 'Some answer 4'
      check('Correct', match: :prefer_exact)
      click_button 'Create Question'
    end

    it { should have_content('Question was successfully created') }
    it { should have_content(question.content) }
  end

  describe 'when I visit the edit question page' do
    before(:each) do
      question.save!
      visit quiz_path(quiz)
      click_link 'edit'
    end
    it { should have_content('Edit question') }
    it { should have_button('Update Question') }
    it { should have_link('Cancel') }
  end

  describe 'when I edit a question' do
    before(:each) do
      @new_question_text = 'Modified question'
      question.save!
      visit quiz_path(quiz)
      click_link 'edit'
      fill_in 'Question', with: @new_question_text
      click_button 'Update Question'
    end
    it "should return me to question's quiz page" do
      expect(current_path).to eq quiz_path(question.quiz)
    end
    it { should have_content(@new_question_text) }
  end

  describe 'when I delete a question' do
    before(:each) do
      question.save!
      visit quiz_path(quiz)
    end

    it 'should return to the show quiz page' do
      click_link 'delete'
      expect(current_path).to eq quiz_path(question.quiz)
    end
    it 'should delete the question' do
      expect do
        click_link 'delete'
      end.to change(quiz.questions, :count).by(-1)
    end
  end

  describe 'when I copy a question' do
    before(:each) do
      # need to reference question so it exists before going to quiz page
      question
      quiz.reload
      visit quiz_path(quiz)
      click_link "#{quiz.questions.first.id}"
    end

    it { should have_content(quiz.questions.first.content) }

    it 'should have all the answers' do
      quiz.questions.first.answers.each do |answer|
        expect(page).to have_content(answer.content)
      end
    end

    it 'should add the copied question' do
      expect do
        click_button 'Create Question'
      end.to change(quiz.questions, :count).by(1)
    end
  end
end
