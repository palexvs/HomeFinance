# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)      not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :password
  has_many :session, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  has_many :accounts, :dependent => :destroy
  has_many :categories, :dependent => :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-_+.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            uniqueness: true,
            length: { maximum: 50 },
            format: { with: VALID_EMAIL_REGEX }
  before_save { self.email = email.downcase }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
