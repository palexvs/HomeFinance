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

  has_many :transaction, :dependent => :destroy
  belongs_to :user

  DATE_FOR_BALANCE_TRANSACTION = DateTime.new(1900).to_s(:db)

  def start_balance
    t_start_balance = Transaction.where("account_id = ? AND date = ?", self.id, DATE_FOR_BALANCE_TRANSACTION).first
    if !t_start_balance.nil?
      t_start_balance.cents_to_money
    else
      0.0
    end
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
            account_id: self.id,
            transaction_type_id: ( @start_balance.to_f >= 0 ? 2 : 1 ) } # 1 - outlay, 2 - income
    t_start_balance = Transaction.where("account_id = ? AND date = ?", self.id, DATE_FOR_BALANCE_TRANSACTION).first_or_initialize
    if !t_start_balance.update_attributes(data)
      # DO SOMTHING
    end
  end

end
