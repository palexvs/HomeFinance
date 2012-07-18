# == Schema Information
#
# Table name: transaction_types
#
#  id          :integer         not null, primary key
#  name        :string(255)     not null
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class TransactionType < ActiveRecord::Base
  attr_accessible :name
  validates :name, :presence => true
  
  has_many :transaction
end
