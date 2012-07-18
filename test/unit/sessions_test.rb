# == Schema Information
#
# Table name: sessions
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  sid        :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'test_helper'

class SessionsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
