require 'spec_helper'

=begin

Note: I am using devise for authentication. It feels redundant to have
these tests, since devise should also have these tests or something 
similar.

I'm providing these anyway because:

  1. if I want to replace devise with my own authentication in 
  the future, these tests will already be here.

  2. as devise gets updated something could break related to my
  specific environment and my tests will catch that.

However, these tests are not as all-encompassing as they would be if
I had written the authentication myself. They are just enough to let
me know if things have gone horribly wrong.

=end

describe User do

	let(:user) { FactoryGirl.create(:user) }
	
  subject { user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  context "when email is missing" do
  	before { user.email = '' }
  	it { should_not be_valid }
  end

  context "when password is missing" do
  	before { user.password = '' }
  	it { should_not be_valid }
  end

  context "when password_confirmation is missing" do
  	before { user.password_confirmation = '' }
  	it { should_not be_valid }
  end

  context "when password and password_confirmation don't match" do
  	before { user.password_confirmation = "something_else" }
  	it { should_not be_valid }
  end

  context "when password is too short" do
  	before do 
  		user.password = "foobar"
  		user.password_confirmation = "foobar"
  	end
  	it { should_not be_valid }
  end

  context "when email format is invalid" do
  	it "should not be valid" do
  		addresses = %w[user@foo @foo.com user_at_foo.com 
  			user@foo,com]
  		addresses.each do |address|
  			user.email = address
  			expect(user).to_not be_valid
  			expect(user.errors.messages).to include(:email)
  		end
  	end
  end

  context "when email format is valid" do
  	it "should be valid" do
			addresses = %w[user@foo.com 1@fee.foo.fun 1.2-+a@v.p USER@S.WHOOOP] 
			addresses.each do |address|
				user.email = address
				expect(user).to be_valid
			end  		
  	end
  end

  context "when email is already taken" do
	
		let(:user2) { user.dup }  	

  	it "should have email already taken error" do
  		expect(user2).to_not be_valid
	  	expect(user2.errors.messages).to include(:email)
  		expect(user2.errors.messages[:email].shift).to match(/already been taken/)
  	end
  end

	context "authenticating a user" do
	  before(:each) do
	  	user.password = "foobarbaz"
	  	user.password_confirmation = "foobarbaz"
	  end

	  it "will validate a correct password" do
	    user.valid_password?("foobarbaz").should be_true
	  end
	  
	  it "will not validate an incorrect password" do
	    user.valid_password?("invalid_foo").should be_false
	  end
	end
end



















