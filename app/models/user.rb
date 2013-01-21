class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :transactions, :dependent => :destroy
  has_many :accounts, :dependent => :destroy
  has_many :categories, :dependent => :destroy

  after_create :init

  private
  def init
    self.accounts.create(name: "Cash", currency: 'UAH')
    self.categories.create(name: "Default", type_id: Transaction::TYPES.index("income"))
    self.categories.create(name: "Default", type_id: Transaction::TYPES.index("outlay"))
    true
  end

end
