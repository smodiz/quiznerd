require 'spec_helper'

describe Dashboard do
  let(:user) { FactoryGirl.create(:user) }

  describe '#initialize' do
    it "loads the user's quizzes, quiz_events" do
      limit = 2
      quizzes = sorted_quizzes(3)
      quiz_events = sorted_quiz_events(3, quizzes.first)
      dashboard = Dashboard.new(user, limit)

      expect(dashboard.quizzes.map(&:id)).to \
        match_array quizzes.slice(0, limit).map(&:id)
      expect(dashboard.quiz_events).to match_array quiz_events.slice(0, limit)
      expect(dashboard.remaining_quizzes_count).to eq 1
      expect(dashboard.remaining_events_count).to eq 1
    end

    it "does not load other users' quiz data" do
      quiz_for_user = FactoryGirl.create(:quiz, author: user)
      quiz_for_other_user = FactoryGirl.create(:quiz)
      dashboard = Dashboard.new(user, 10)
      expect(dashboard.quizzes).to include quiz_for_user
      expect(dashboard.quizzes).not_to include quiz_for_other_user
    end

    it "does not load other users' quiz event data" do
      event_for_user = FactoryGirl.create(:quiz_event, user: user)
      event_for_other_user = FactoryGirl.create(:quiz_event)
      dashboard = Dashboard.new(user, 10)
      expect(dashboard.quiz_events).to include event_for_user
      expect(dashboard.quiz_events).not_to include event_for_other_user
    end
  end

  # supporting methods
  def sorted_quizzes(num)
    (1..num).each_with_object([]) do |_n, obj|
      obj << FactoryGirl.create(:quiz, author: user)
    end.sort! { |a, b| a.updated_at <=> b.updated_at }.reverse
  end

  def sorted_quiz_events(num, quiz)
    (1..num).each_with_object([]) do |_n, obj|
      obj << FactoryGirl.create(:quiz_event, user: user, quiz: quiz)
    end.sort! { |a, b| a.updated_at <=> b.updated_at }.reverse
  end
end
