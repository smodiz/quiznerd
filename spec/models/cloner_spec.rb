require 'spec_helper'

describe Cloner do 

  let(:quiz) { FactoryGirl.create(:quiz) }
  
  describe "#clone" do
    before(:each) do
      @cloned_obj = Cloner.clone(quiz)
    end

    it "should copy an object" do
      expect(@cloned_obj.name).to eq quiz.name
    end

    it "should not copy id" do
      expect(@cloned_obj.id).to be_nil
    end

    it "should not copy created_at" do
      expect(@cloned_obj.created_at).to be_nil
    end

    it "should not copy updated_at" do
      expect(@cloned_obj.updated_at).to be_nil
    end

  end

end



