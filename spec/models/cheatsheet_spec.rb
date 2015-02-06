require 'spec_helper'

describe Cheatsheet do
  
  it "is invalid without title, content, and status" do
    cs = Cheatsheet.new
    expect(cs.valid?).to eq false
    expect(cs.errors).to include(:title)
    expect(cs.errors).to include(:content)
    expect(cs.errors).to include(:status_id)
  end

  it "is valid with title, content, and status" do
    cs = Cheatsheet.new(title: "A title", status_id: 1, content: "Wut?")
    expect(cs.valid?).to eq true
  end

  it "allows large content" do
    big = "a"*400    
    cs = Cheatsheet.new(title: "A title", status_id: 1, content: big)
    expect { cs.save }.to_not raise_error
  end

  describe "#seach_owned_by" do
    let(:user) { FactoryGirl.create(:user) }
    let(:cs_1) { FactoryGirl.create(:cheatsheet,  title:     "Rails 4", 
                                                  user:       user, 
                                                  status_id:   1,
                                                  tag_list:   "rails, cool") }
    let(:cs_2) { FactoryGirl.create(:cheatsheet,  title:     "Java 4", 
                                                  user:       user, 
                                                  status_id:   1,
                                                  tag_list:   "java, cool") }
    let(:cs_3) { FactoryGirl.create(:cheatsheet,  title:      "Rails Syntax", 
                                                  user:       user,
                                                  tag_list:   "rails") }
    let(:cs_4) { FactoryGirl.create(:cheatsheet,  title:     "Rails Validations",
                                                  tag_list:  "rails, cool") }
    
    before(:each) do
      # touch these to make sure they are created before tests
      user; cs_1; cs_2; cs_3; cs_4
    end

    describe "when given a search term" do
      it "returns the matching records for that user" do
        results = Cheatsheet.search_owned_by(user, "Rails", "")
        expect(results.size).to eq 2
        expect(results).to match_array([cs_1, cs_3])
      end
    end

    describe "when given a tag" do
      it "returns the matching records for that user and tag" do
        results = Cheatsheet.search_owned_by(user, "", "cool")
        expect(results).to match_array([cs_1, cs_2])
      end
    end

    describe "when not given a search term or tag" do
      it "returns all the records for that user" do
        results = Cheatsheet.search_owned_by(user,"", "")
        expect(results.size).to eq 3
        expect(results).to match_array([cs_1, cs_2, cs_3])
      end
    end
  end


end
