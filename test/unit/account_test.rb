# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :string(255)
#  currency      :string(3)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  balance_cents :integer          default(0), not null
#  user_id       :integer
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
