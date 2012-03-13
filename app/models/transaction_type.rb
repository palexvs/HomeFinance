class TransactionType < ActiveRecord::Base
  validates :name, :presence => true
  
  has_many :transaction
end
