class Account < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :currency, :presence => true, :length => {:is => 3}
  validates :balance, :presence => true
  
  has_many :transaction
end
