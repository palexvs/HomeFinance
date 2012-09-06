# == Schema Information
#
# Table name: transactions
#
#  id                  :integer          not null, primary key
#  text                :string(255)
#  amount_cents        :integer          default(0), not null
#  date                :date             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  transaction_type_id :integer          not null
#  account_id          :integer          not null
#  user_id             :integer          not null
#  trans_account_id    :integer
#  trans_amount_cents  :integer          default(0), not null
#

require 'spec_helper'

describe Transaction do

  before do
    @user = create(:user)
    @account = create(:account, user: @user)
    @t = build(:transaction, user: @user, account: @account)
  end

  subject { @t }

  it { should respond_to(:text) }
  it { should respond_to(:date) }
  it { should respond_to(:transaction_type_id) }
  it { should respond_to(:amount) }
  it { should respond_to(:amount_cents) }
  it { should respond_to(:account_id) }
  it { should respond_to(:trans_amount) }
  it { should respond_to(:trans_amount_cents) }
  it { should respond_to(:trans_account_id) }
  it { should respond_to(:user_id) }
  it { should be_valid }

# Tests for TEXT
  describe "when text is empty" do
    before { @t.text = "" }
    it { should be_valid }
  end

  describe "when text lenght > 255" do
    before { @t.text = "a" * 256 }
    it { should_not be_valid }
  end

  describe "when text lenght == 255" do
    before { @t.text = "a" * 255 }
    it { should be_valid }
  end  

# Tests for DATE
  describe "when date is empty" do
    before { @t.date = "" }
    it { should_not be_valid }
  end

  describe "when date has right format" do
    before { @t.date = "2012-09-05" }
    it { should be_valid }
  end

  describe "when date has wrong format" do
    before { @t.date = "2012a/09a/05" }
    it { should_not be_valid }
  end

# Tests for TRANSACTION_TYPE_ID
  describe "when transaction_type_id is empty" do
    before { @t.transaction_type_id = nil }
    it { should_not be_valid }
  end

  describe "when transaction_type_id is right" do
    before { @t.transaction_type_id = TransactionType.first.id }
    it { should be_valid }
  end

  describe "when transaction_type_id is wrong" do
    before { @t.transaction_type_id = TransactionType.last.id + 1 }
    it { should_not be_valid }
  end

# Tests for AMOUNT
  describe "when amount set empty" do
    before { @t.amount = "" }
    it { should be_valid }
    it { @t.amount.should == 0.0 }
    it { @t.amount_cents.should == 0 }
  end

  describe "when amount set 0" do
    before { @t.amount = 0 }
    it { should be_valid }
    it { @t.amount.should == 0.0 }
    it { @t.amount_cents.should == 0 }
  end

  describe "when amount is 10.99" do
    before { @t.amount = 10.99 }
    it { should be_valid }
    it { @t.amount_cents.should == 1099 }
  end  

  describe "when amount is < 0" do
    before { @t.amount = -10.99 }
    it { should_not be_valid }
    it { @t.amount_cents.should == -1099 }
  end

  describe "when amount is big (99 999 999.99)" do
    before { @t.amount = "99 999 999.99" }
    it { should be_valid }
    it { @t.amount_cents.should == 9999999999 }
  end

# Tests for AMOUNT_CENTS
  describe "when amount_cents set empty" do
    before { @t.amount_cents = nil }
    it { should_not be_valid }
    it { @t.amount.should == nil }
    it { @t.amount_cents.should == nil }
  end

  describe "when amount_cents set 0" do
    before { @t.amount_cents = "0.0" }
    it { should be_valid }
    it { @t.amount.should == 0.0 }
    it { @t.amount_cents.should == 0 }
  end

  describe "when amount_cents is 10.99" do
    before { @t.amount_cents = 1099 }
    it { should be_valid }
    it { @t.amount.should == 10.99 }
  end  

  describe "when amount_cents is < 0" do
    before { @t.amount_cents = -1099 }
    it { should_not be_valid }
    it { @t.amount.should == -10.99 }
  end

  describe "when amount_cents is big (99 999 999.99)" do
    before { @t.amount_cents = 9999999999 }
    it { should be_valid }
    it { @t.amount.should == 99999999.99 }
  end

# Tests for ACCOUNT_ID
  describe "when account_id is empty" do
    before { @t.account_id = nil }
    it { should_not be_valid }
  end

  describe "when account_id is right" do
    before { @t.account_id = @account.id }
    it { should be_valid }
  end

  describe "when account_id is wrong" do
    before { @t.account_id = Account.last.id + 1 }
    it { should_not be_valid }
  end

# Tests for USER_ID
  describe "when user_id is empty" do
    before { @t.user_id = nil }
    it { should_not be_valid }
  end

  describe "when user_id is right" do
    before { @t.user_id = @user.id }
    it { should be_valid }
  end

  describe "when user_id is wrong" do
    before { @t.user_id = User.last.id + 1 }
    it { should_not be_valid }
  end

# SECURITY  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect { Transaction.new(user_id: @user.id) }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to amount_cents" do
      expect { Transaction.new(amount_cents: 0) }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to trans_amount_cents" do
      expect { Transaction.new(trans_amount_cents: 0) }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end  
  end

end