# == Schema Information
#
# Table name: transactions
#
#  id                  :integer         not null, primary key
#  text                :string(255)
#  amount              :integer
#  date                :date
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  transaction_type_id :integer         not null
#  account_id          :integer         default(1), not null
#  user_id             :integer
#

require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
