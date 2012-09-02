# == Schema Information
#
# Table name: accounts
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  currency    :string(3)        not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  balance     :integer          default(0), not null
#  user_id     :integer
#

class Account < ActiveRecord::Base
  attr_accessible :name, :description, :currency, :start_balance

  validates :name, :presence => true, :uniqueness => true
  validates :currency, :presence => true, :length => {:is => 3}
  validates :balance, :presence => true

  has_many :transaction, :class_name => 'Transaction', :foreign_key => 'account_id'
  has_many :trans_transaction, :class_name => 'Transaction', :foreign_key => 'trans_account_id'


  belongs_to :user

  DATE_FOR_BALANCE_TRANSACTION = DateTime.new(1900).to_s(:db)

  def start_balance
    t_start_balance = Transaction.where("account_id = ? AND date = ?", id, DATE_FOR_BALANCE_TRANSACTION).first_or_initialize
    t_start_balance.amount
  end

  def start_balance=(amount)
    @start_balance = amount
  end

  after_save :set_start_balance

  private

  def set_start_balance
    data = { amount: @start_balance,
            date: DATE_FOR_BALANCE_TRANSACTION, 
            text: "set start balance", 
            account_id: id,
            transaction_type_id: ( @start_balance.to_f >= 0 ? 2 : 1 ) } # 1 - outlay, 2 - income
    t_start_balance = User.find(user_id).transaction.where("account_id = ? AND date = ?", id, DATE_FOR_BALANCE_TRANSACTION).first_or_initialize
    if !t_start_balance.update_attributes(data)
      # DO SOMTHING
    end
  end

end
