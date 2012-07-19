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

class Sessions < ActiveRecord::Base
  attr_accessible :sid, :user_id

  belongs_to :user

  validates :user_id, presence: true

  before_save :create_sid

  def create_sid
      self.sid = SecureRandom.urlsafe_base64
    end
end
