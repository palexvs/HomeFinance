# == Schema Information
#
# Table name: transactions
#
#  id                  :integer          not null, primary key
#  text                :string(255)
#  amount              :integer
#  date                :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  transaction_type_id :integer          not null
#  account_id          :integer          default(1), not null
#  user_id             :integer
#

class Transaction < ActiveRecord::Base
  attr_accessible :amount, :date, :text, :transaction_type_id, :account_id
  validates :amount, :presence => true
  validates :date, :presence => true
  validates :transaction_type_id, :presence => true
  validates :account_id, :presence => true

  belongs_to :transaction_type
  delegate :name, :to => :transaction_type, :prefix => true

  belongs_to :account
  delegate :name, :to => :account, :prefix => true

  belongs_to :user

  scope :with_type, includes(:transaction_type)
  scope :with_account, includes(:account)

  before_create :update_balance_create
  before_destroy :update_balance_destroy
  before_update :update_balance_update

  private
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
