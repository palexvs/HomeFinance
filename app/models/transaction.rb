# == Schema Information
#
# Table name: transactions
#
#  id                  :integer          not null, primary key
#  text                :string(255)
#  amount_cents        :integer
#  date                :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  transaction_type_id :integer          not null
#  account_id          :integer          default(1), not null
#  user_id             :integer
#  trans_account_id    :integer
#  trans_amount_cents  :integer
#

class Transaction < ActiveRecord::Base
  attr_accessible :text, :date, :transaction_type_id, :amount, :account_id, :trans_amount, :trans_account_id

  validates :date, :presence => true
  validates :transaction_type_id, :presence => true
 
  monetize :amount_cents
  validates :amount, :presence => true, :numericality => { :greater_than_or_equal_to  => 0 }
  validates :account_id, :presence => true
  belongs_to :account, :class_name => "Account", :foreign_key => :account_id
  delegate :name, :to => :account, :prefix => true  

  monetize :trans_amount_cents, :allow_nil => true
  validates :trans_amount, :presence => true, :numericality => { :greater_than_or_equal_to  => 0 }, :if => :is_transfer?
  validates :trans_account_id, :presence => true, :if => :is_transfer?
  belongs_to :trans_account, :class_name => "Account", :foreign_key => :trans_account_id  
  delegate :name, :to => :trans_account, :prefix => true  

  validate :has_access_to_account

  belongs_to :transaction_type
  delegate :name, :to => :transaction_type, :prefix => true

  belongs_to :user

  scope :with_type, includes(:transaction_type)
  scope :with_account, includes(:account, :trans_account)
  scope :order_date, order("date desc,id desc")

  before_create :update_balance_create
  before_destroy :update_balance_destroy
  before_update :update_balance_update

  def is_transfer?
    transaction_type_id == 3
  end

  private

  def has_access_to_account
    if Account.where("id = ? AND user_id = ?", account_id, user_id).empty?
      errors.add(:account_id, "Wrong account")
    end

    if !trans_account_id.nil?
      if Account.where("id = ? AND user_id = ?", trans_account_id, user_id).empty?
        errors.add(:trans_account_id, "Wrong account")
      end 
    end   
  end

  def update_balance_create(t = self)
    offset = get_amount_with_sign(t)

    Account.update_counters t.account_id, :balance => offset
  end

  def update_balance_destroy(t = self)
    offset = get_amount_with_sign(t)

    Account.update_counters t.account_id, :balance => offset*(-1)
  end

  def update_balance_update
    transaction_old = Transaction.find(id)

    update_balance_destroy(transaction_old)
    update_balance_create(self)
  end

  def get_amount_with_sign(t = self)
    sign_amount = case TransactionType.find(t.transaction_type_id).name
      when "outlay" then t.amount*(-1)
       else t.amount
    end

    return sign_amount
  end
end
