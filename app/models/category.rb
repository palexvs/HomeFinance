# == Schema Information
#
# Table name: categories
#
#  id        :integer          not null, primary key
#  name      :string(255)      not null
#  user_id   :integer          not null
#  parent_id :integer
#  lft       :integer
#  rgt       :integer
#  depth     :integer
#  type_id   :integer          not null
#

class Category < ActiveRecord::Base  
  acts_as_nested_set
  include TheSortableTree::Scopes

  attr_accessible :name, :parent_id, :type_id, :user_id

  has_many :transactions, :dependent => :destroy

  belongs_to :user
  validates :user_id, :presence => true

  validates :type_id, :presence => true #, :inludes => { 0..[].length}

  Transaction::TYPES.each_with_index do |type, i|
    scope "#{type}".to_sym, where(type_id: i)
  end
end
