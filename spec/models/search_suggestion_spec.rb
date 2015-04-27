require 'rails_helper'

describe SearchSuggestion do

  before(:each) do
    quiz_name = 'Ruby For Ruby Lovers'
    category_name = 'Programming'
    subject_name = 'Ruby'
    @quiz = double('quiz', 
                   name: quiz_name, 
                   category_name: category_name,
                   subject_name: subject_name)
  end

  it 'indexes quiz data' do
    SearchSuggestion.index_quiz(@quiz)

    expect(suggestions_for('r')).to eq ['ruby','ruby for ruby lovers']
    expect(suggestions_for('ru')).to eq ['ruby','ruby for ruby lovers']
    expect(suggestions_for('p')).to eq ['programming']
    expect(suggestions_for('l')).to eq ['lovers']
    expect($redis.zscore 'search-suggestions:r', 'ruby').to eq 2.0
  end

  it 'unindexes quiz data' do
    SearchSuggestion.index_quiz(@quiz)
    expect(suggestions_for('r')).to eq ['ruby','ruby for ruby lovers']
    SearchSuggestion.unindex_quiz(@quiz)
    expect(suggestions_for('r')).to eq []
  end

  it 'clears all the search-suggestions' do
    SearchSuggestion.index_quiz(@quiz)
    expect(suggestions_for('r')).to eq ['ruby','ruby for ruby lovers']
    SearchSuggestion.clear

    expect(suggestions_for('r')).to eq []
  end

  it 'indexes all the quizzes' do
    quiz1 = FactoryGirl.create(:quiz, name: 'Quiz 1', published: true)
    quiz2 = FactoryGirl.create(:quiz, name: 'quiz 2', published: true)
    
    SearchSuggestion.index_quizzes
    
    expect(suggestions_for(quiz1.name[0].downcase)).to match_array \
      [quiz1.name.downcase, quiz2.name.downcase]
  end

  def suggestions_for(str)
    $redis.zrevrange "search-suggestions:#{str}", 0, 9
  end
end
