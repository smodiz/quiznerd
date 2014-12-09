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

end
