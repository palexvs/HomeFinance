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

class Account < ActiveRecord::Base
  attr_accessible :name, :description, :currency

  monetize :balance_cents
  validates :balance, :numericality => true
  validates :name, :presence => true, :length => {:maximum => 15},
            :uniqueness => {:scope => [:currency, :user_id], :message => "Account with such Name and Currency already exists"}
  validates :description, :length => {:maximum => 255}
  validates :currency, :presence => true, :length => {:is => 3}, :inclusion => {:in => Finance::Application.config.currency_list}

  has_many :transactions, :class_name => 'Transaction', :foreign_key => 'account_id'
  has_many :trans_transactions, :class_name => 'Transaction', :foreign_key => 'trans_account_id'

  belongs_to :user
  validates :user_id, :presence => true

  default_scope order(:id)

  before_create :set_balance

  def as_json (options = nil)
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:balance])
    super options
  end

  private
  def set_balance
    self.balance = 0
  end

end