# == Schema Information
#
# Table name: accounts
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  currency    :string(3)       not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  balance     :integer         default(0), not null
#

class Account < ActiveRecord::Base
  attr_accessible :name, :description, :currency, :balance

  validates :name, :presence => true, :uniqueness => true
  validates :currency, :presence => true, :length => {:is => 3}
  validates :balance, :presence => true

  has_many :transaction
  belongs_to :user
end
