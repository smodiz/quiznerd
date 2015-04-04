require 'spec_helper'

def required_fields
  [:name, :description, :category_id, :subject_id, :author, :published]
end

describe Quiz do
  let(:quiz) { FactoryGirl.create(:quiz_with_questions) }

  subject { quiz }

  it { should be_valid }

  required_fields.each do |attr|
    describe "when required field #{attr} is nil" do
      before(:each) do
        quiz.send(attr.to_s + '=', nil)
        quiz.valid?
      end
      it { should_not be_valid }
      it "should have an error for required field #{attr} not set" do
        expect(quiz.errors.messages).to include(attr)
      end
    end
  end

  describe 'search' do
    before(:each) do
      FactoryGirl.create(:quiz_with_questions, name: 'Rails 101')
      FactoryGirl.create(:quiz_with_questions, name: 'Ruby 101')
      FactoryGirl.create(:quiz_with_questions, name: 'jQuery')
      FactoryGirl.create(:quiz, name: 'CSS 101', published: false)
    end

    context 'when given a search key word' do
      it 'should return only the matching records for publishd quizzes' do
        @quizzes = Quiz.search_quiz_to_take('101')
        expect(@quizzes.size).to eq 2
        @quizzes.each do |quiz|
          expect(quiz.name).to match(/101/)
          expect(quiz.name).not_to match(/CSS/)
        end
      end
    end

    context 'when no search terms given' do
      it 'should return all records' do
        @quizzes = Quiz.search_quiz_to_take('')
        expect(@quizzes.size).to eq 3
      end
    end
  end

  describe 'removing the last question' do
    it 'should change published to false' do
      quiz.questions.each(&:destroy)
      expect(quiz.published).to eq false
    end
  end

  describe 'name should not exceed 45 characters' do
    before do
      quiz.name = 'a' * 46
      quiz.valid?
    end

    it 'should have an error' do
      expect(quiz.errors).to include(:name)
      expect(quiz.errors.messages[:name].to_s).to match(/is too long/)
    end
  end
end
