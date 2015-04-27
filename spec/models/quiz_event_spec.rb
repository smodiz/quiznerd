require 'spec_helper'

describe QuizEvent do
  let(:quiz_event)  { FactoryGirl.create(:quiz_event) }
  let(:number_of_questions) { quiz_event.number_of_questions }

  subject { quiz_event }

  describe 'should respond to fields' do
    [:user, :quiz, :status, :total_correct, :total_answered,
     :last_question_id].each do |attr|
      it { should respond_to(attr) }
    end
  end

  describe '#update_status' do
    it 'updates the status when all the questions have been answered' do
      expect(quiz_event).not_to be_completed
      quiz_event.total_answered = number_of_questions
      expect(quiz_event).to be_completed
    end

    it 'does not update status unless all the questions have been answered' do
      quiz_event.total_answered = (number_of_questions.to_i - 1)
      expect(quiz_event).not_to be_completed
    end
  end

  describe 'search' do
    before do
      @quiz = FactoryGirl.create(:quiz)
      FactoryGirl.create(:quiz_event, quiz: @quiz, user: @quiz.author)
      FactoryGirl.create(:quiz_event, quiz: @quiz, user: @quiz.author)
      # some other quiz
      @qe_3 = FactoryGirl.create(:quiz_event, user: @quiz.author)
    end

    context 'when given a search key word' do
      it 'should return only the matching records for publishd quizzes' do
        @quiz_events = QuizEvent.search_quizzes_taken(@quiz.name, @quiz.author)
        expect(@quiz_events.size).to eq 2
        @quiz_events.each do |quiz_event|
          expect(quiz_event.quiz_name).to eq @quiz.name
          expect(quiz_event.quiz_name).not_to eq @qe_3.quiz.name
        end
      end
    end

    context 'when no search terms given' do
      it 'should return all records' do
        @quiz_events = QuizEvent.search_quizzes_taken(nil, @quiz.author)
        expect(@quiz_events.size).to eq 3
      end
    end
  end
end
