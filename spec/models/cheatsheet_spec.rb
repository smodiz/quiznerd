require 'spec_helper'

describe Cheatsheet do
  it 'is invalid without title, content, and status' do
    cs = Cheatsheet.new
    expect(cs.valid?).to eq false
    expect(cs.errors).to include(:title)
    expect(cs.errors).to include(:content)
  end

  it 'is valid with title, content, and status' do
    cs = Cheatsheet.new(title: 'A title', content: 'Wut?')
    expect(cs.valid?).to eq true
  end

  it 'allows large content' do
    big = 'a' * 400
    cs = Cheatsheet.new(title: 'A title', content: big)
    expect { cs.save }.to_not raise_error
  end

  describe '#seach_owned_by' do
    let(:user) { FactoryGirl.create(:user) }
    let(:cs_1) do
      FactoryGirl.create(:cheatsheet,  title:     'Rails 4',
                                       user:       user,
                                       tag_list:   'rails, cool')
    end
    let(:cs_2) do
      FactoryGirl.create(:cheatsheet,  title:     'Java 4',
                                       user:       user,
                                       tag_list:   'java, cool')
    end
    let(:cs_3) do
      FactoryGirl.create(:cheatsheet,  title:      'Rails Syntax',
                                       user:       user,
                                       tag_list:   'rails')
    end
    let(:cs_4) do
      FactoryGirl.create(:cheatsheet,  title:     'Rails Validations',
                                       tag_list:  'rails, cool')
    end

    before(:each) do
      # touch these to make sure they are created before tests
      user
      cs_1
      cs_2
      cs_3
      cs_4
    end

    describe 'when given a search term' do
      it 'returns the matching records for that user' do
        results = Cheatsheet.search_owned_by(user, 'Rails', '')
        expect(results.size).to eq 2
        expect(results).to match_array([cs_1, cs_3])
      end
    end

    describe 'when given a tag' do
      it 'returns the matching records for that user and tag' do
        results = Cheatsheet.search_owned_by(user, '', 'cool')
        expect(results).to match_array([cs_1, cs_2])
      end
    end

    describe 'when not given a search term or tag' do
      it 'returns all the records for that user' do
        results = Cheatsheet.search_owned_by(user, '', '')
        expect(results.size).to eq 3
        expect(results).to match_array([cs_1, cs_2, cs_3])
      end
    end
  end
end
