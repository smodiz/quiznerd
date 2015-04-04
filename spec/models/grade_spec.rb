require 'spec_helper'

describe Grade do
  it 'returns a percent score rounded to nearest integer' do
    expect(Grade.new(8, 11).percent).to eq 73
  end
end
