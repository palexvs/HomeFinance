# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  description   :string(255)
#  currency      :string(3)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  balance_cents :integer          default(0), not null
#  user_id       :integer          not null
#
require 'spec_helper'

describe Account do

  before do
    @user = create(:user)
    @account = create(:account, user: @user)
  end

  subject { @account }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:currency) }
  it { should respond_to(:balance) }
  it { should respond_to(:balance_cents) }
  it { should respond_to(:user_id) }
  it { should be_valid }

# Tests for NAME
  describe "when name is empty" do
    before { @account.name = "" }
    it { should_not be_valid }
  end

  describe "when name length > 15" do
    before { @account.name = "a" * 16 }
    it { should_not be_valid }
  end  

  describe "when name length == 15" do
    before { @account.name = "a" * 15 }
    it { should be_valid }
  end

# Tests for DESCRIPTION
  describe "when description is empty" do
    before { @account.description = "" }
    it { should be_valid }
  end

  describe "when description length > 255" do
    before { @account.description = "a" * 256 }
    it { should_not be_valid }
  end  

  describe "when description length == 255" do
    before { @account.description = "a" * 255 }
    it { should be_valid }
  end  

# Tests for balance
  describe "when balance set empty" do
    before { @account.balance = "" }
    it { should be_valid }
    it { @account.balance.should == 0.0 }
    it { @account.balance_cents.should == 0 }
  end

  describe "when balance is 10.99" do
    before { @account.balance = 10.99 }
    it { should be_valid }
    it { @account.balance_cents.should == 1099 }
  end  

  describe "when balance is < 0" do
    before { @account.balance = -10.99 }
    it { should be_valid }
    it { @account.balance_cents.should == -1099 }
  end

  describe "when balance is big (99 999 999.99)" do
    before { @account.balance = "99 999 999.99" }
    it { should be_valid }
    it { @account.balance_cents.should == 9999999999 }
  end

# Tests for balance_CENTS
  describe "when balance set empty" do
    before { @account.balance_cents = nil }
    it { should_not be_valid }
    it { @account.balance.should == nil }
    it { @account.balance_cents.should == nil }
  end

  describe "when balance is 10.99" do
    before { @account.balance_cents = 1099 }
    it { should be_valid }
    it { @account.balance.should == 10.99 }
  end  

  describe "when balance is < 0" do
    before { @account.balance_cents = -1099 }
    it { should be_valid }
    it { @account.balance.should == -10.99 }
  end

  describe "when balance is big (99 999 999.99)" do
    before { @account.balance_cents = 9999999999 }
    it { should be_valid }
    it { @account.balance.should == 99999999.99 }
  end

# Tests for USER_ID
  describe "when user_id is empty" do
    before { @account.user_id = nil }
    it { should_not be_valid }
  end

  describe "when user_id is right" do
    before { @account.user_id = @user.id }
    it { should be_valid }
  end

# SECURITY  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect { Account.new(user_id: @user.id) }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to balance_cents" do
      expect { Account.new(balance: 0) }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to trans_balance_cents" do
      expect { Account.new(balance_cents: 0) }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end  
  end

end