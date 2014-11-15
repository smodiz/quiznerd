require 'spec_helper'

describe "QuizMerge" do

  subject { QuizMerge.new }
  
  describe "should act like a model" do
    [:valid?, :persisted?].each do |m|
      it { should respond_to(m) }
    end
  end

  describe "should have attributes" do
    [:target_quiz_id, :source_quiz_id, :user].each do |attr|
      it { should respond_to(attr) }
    end
  end

  it "returns a list of mergeable quizzes" do
    user        = new_user
    mergeable1  = quiz_for(user)
    mergeable2  = quiz_for(user)

    other_user        = new_user
    other_user_quiz   = quiz_for(other_user)
    
    actuals = QuizMerge.mergable_quizzes_for(user)

    expect(actuals).to      include mergeable1
    expect(actuals).to      include mergeable2
    expect(actuals).to_not  include other_user_quiz
  end

  describe "validation" do
    let(:user)          { new_user }
    let(:quiz)          { quiz_for(user) }
    let(:another_quiz)  { quiz_for(user) }
    let(:bad_quiz)      { quiz_for(new_user) }

    it "fails validation if the source and the target id are same" do
      m = QuizMerge.new({ 
        target_quiz_id: quiz.id, 
        source_quiz_id: quiz.id, 
        user: user 
      })
      m.valid?
      expect(m.errors).to include(:target_quiz_id) 
    end

    it "fails validation if the target id missing" do
      m = QuizMerge.new({ 
        target_quiz_id: nil, 
        source_quiz_id: quiz.id, 
        user: user 
      })
      m.valid?
      expect(m.errors).to include(:target_quiz_id) 
    end

    it "fails validation if the source id missing" do
      m = QuizMerge.new({ 
        target_quiz_id: quiz.id, 
        source_quiz_id: nil, 
        user: user 
      })
      m.valid?
      expect(m.errors).to include(:source_quiz_id) 
    end

    it "fails validation if the user is not the author of both quizes" do
      m = QuizMerge.new({
        target_quiz_id: quiz.id, 
        source_quiz_id: bad_quiz.id, 
        user: user 
      })
      m.valid?
      expect(m.errors).to include(:base) 
    end

    it "passes validation when valid" do
      m = QuizMerge.new({ target_quiz_id: quiz.id, source_quiz_id: another_quiz.id, user: user })
    end
  end

  describe "merge" do
    let(:user)        { new_user }
    let(:target)      { quiz_for(user) }
    let(:source)      { quiz_for(user) }
    let(:quiz_event)  { quiz_event_for(source) }
    let(:quiz_event2) { quiz_event_for(source) }

    let(:unrelated_quiz)  { quiz_for(user) }
    let(:unrelated_event) { quiz_event_for(unrelated_quiz) }

    before(:each) do
      m = QuizMerge.new(
        source_quiz_id: source.id, 
        target_quiz_id: target.id, 
        user: target.author
      )
      m.save
    end

    it "puts the questions on the target quiz" do
      modified_target = Quiz.find(target.id)
      expect(questions_for_quiz(modified_target)).to eql(
        combined_questions(source, target))
    end

    it "updates all quiz events to point to the target quiz" do
      events = QuizEvent.where(quiz_id: source.id)
      expect(events).to be_empty
    end

    it "does not update unrelated quiz events" do
      expect(unrelated_event.quiz_id).to eql unrelated_quiz.id
    end

    it "removed the source quiz" do
      expect { Quiz.find(source.id) }.to raise_error(
        ActiveRecord::RecordNotFound)
    end  

  end

  def questions_for_quiz(quiz)
    quiz.questions.map { |q| q.content }.sort
  end

  def combined_questions(quiz1, quiz2)
    (questions_for_quiz(quiz1) + questions_for_quiz(quiz2)).sort 
  end  

  def new_user
    FactoryGirl.create(:user)
  end

  def quiz_for(user)
    FactoryGirl.create(:quiz_with_questions, author: user)
  end

  def quiz_event_for(quiz)
    FactoryGirl.create(:quiz_event, quiz_id: quiz.id)
  end  
end