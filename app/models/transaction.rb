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
#  category_id         :integer
#

class Transaction < ActiveRecord::Base
  attr_accessible :text, :date, :transaction_type_id, :amount, :account_id, :trans_amount, :trans_account_id, :category_id

  TYPES = %w[outlay income transfer]

  validates :text, :length => { :maximum => 255 }
  validates :date, :presence => true
  validates :transaction_type_id, :presence => true
 
  monetize :amount_cents, :allow_nil => true
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
  validate :date_is_date?
  validate :transaction_type_exists?

  belongs_to :transaction_type
  delegate :name, :to => :transaction_type, :prefix => true

  belongs_to :user
  validates :user_id, :presence => true

  belongs_to :category
  validates :category_id, :presence => true 
  delegate :name, :to => :category, :prefix => true, :allow_nil => true

  scope :with_type, includes(:transaction_type)
  scope :with_account, includes(:account, :trans_account)
  default_scope order("date desc,id desc")

  before_create :update_balance_create
  before_destroy :update_balance_destroy
  before_update :update_balance_update


  def as_json (options = nil)
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:amount,:trans_amount])
    super options
  end

  def is_transfer?
    transaction_type_id == 3
  end

  private

  def transaction_type_exists?
    if !TransactionType.exists?(transaction_type_id)
      errors.add(:transaction_type_id, 'Does not exist') 
    end
  end

  def date_is_date?
    if !date.is_a?(Date)
      errors.add(:date, 'Must be a valid date')
    end
  end

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
    Account.update_counters t.account_id, :balance_cents => t.amount_cents*get_sign(t)
    Account.update_counters t.trans_account_id, :balance_cents => t.trans_amount_cents if t.is_transfer?
  end

  def update_balance_destroy(t = self)
    Account.update_counters t.account_id, :balance_cents => t.amount_cents*(-1)*get_sign(t)
    Account.update_counters t.trans_account_id, :balance_cents => t.trans_amount_cents*(-1) if t.is_transfer?
  end

  def update_balance_update
    transaction_old = Transaction.find(id)

    update_balance_destroy(transaction_old)
    update_balance_create(self)
  end

  def get_sign(t = self)
    case t.transaction_type_name
      when "outlay", "transfer"
        -1
      when "income"
        1
      else
        1
        # Add Handle error there !!!
    end
  end
end
