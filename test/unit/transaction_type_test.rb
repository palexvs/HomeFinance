# == Schema Information
#
# Table name: transaction_types
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class TransactionTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
