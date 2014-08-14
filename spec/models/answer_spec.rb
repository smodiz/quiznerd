require 'spec_helper'

describe Answer do

  let(:question) { FactoryGirl.create(:question) }
  let(:answer) { FactoryGirl.create(:answer, question: question) }

  subject { answer }

  it { should be_valid }

  describe "should respond to fields" do
    [:content, :correct].each do |field|
      it { should respond_to(field) }
    end
  end

  [:content, :correct].each do |field|
    describe "when required field #{field} is absent" do
      before(:each) do
        answer.send(field.to_s+"=",nil) 
        answer.valid?
      end

      it { should_not be_valid }
      it  "should have an error for required field #{field} not set" do
        expect(answer.errors.messages).to include(field)
      end
    end
  end

end
