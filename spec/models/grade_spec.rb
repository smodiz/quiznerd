require 'spec_helper'

describe Grade do
  
  it "returns a percent score rounded to nearest integer" do
    expect(Grade.new(8, 11).percent).to eq 73
  end

  describe "#letter" do
    { 100 => "A+", 95 => "A+", 94 => "A", 90 => "A", 85 => "B+", 89 => "B+",
      84 => "B", 80 => "B"}.each do |score, grade|
      it "returns a grade of #{grade} for a score of #{score}" do
        expect(Grade.new(score, 100).letter).to eq grade
      end
    end
  end

end