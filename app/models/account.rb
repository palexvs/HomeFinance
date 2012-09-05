# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :string(255)
#  currency      :string(3)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  balance_cents :integer          default(0), not null
#  user_id       :integer
#

class Account < ActiveRecord::Base
  attr_accessible :name, :description, :currency, :start_balance

  monetize :balance_cents
  validates :name, :presence => true
  validates :currency, :presence => true, :length => {:is => 3}, :inclusion => { :in => Finance::Application.config.currency_list }
  validates :balance, :numericality => true
  validates :start_balance, :numericality => true, :allow_nil => true

  has_many :transaction, :class_name => 'Transaction', :foreign_key => 'account_id'
  has_many :trans_transaction, :class_name => 'Transaction', :foreign_key => 'trans_account_id'


  belongs_to :user

  DATE_FOR_BALANCE_TRANSACTION = DateTime.new(1900).to_s(:db)

  def start_balance
    t = Transaction.where("account_id = ? AND date = ?", id, DATE_FOR_BALANCE_TRANSACTION).first_or_initialize
    t.amount
  end

  def start_balance=(amount)
    @start_balance = amount
  end

  after_save :set_start_balance

  private

  def set_start_balance
    if !@start_balance.nil?
      data = { amount: @start_balance,
              date: DATE_FOR_BALANCE_TRANSACTION, 
              text: "set start balance", 
              account_id: id,
              transaction_type_id: ( @start_balance.to_f >= 0 ? 2 : 1 ) } # 1 - outlay, 2 - income
      t = User.find(user_id).transaction.where("account_id = ? AND date = ?", id, DATE_FOR_BALANCE_TRANSACTION).first_or_initialize
      if !t.update_attributes(data)
        # DO SOMTHING
      end
    end
  end

end
