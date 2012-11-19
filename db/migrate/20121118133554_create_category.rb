class CreateCategory < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name, :null => false
      t.integer :user_id, :null => false
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
    end

    add_column :transactions, :category_id, :integer

    add_index :categories, :user_id
  end

  def self.down
    drop_table :categories
  end
end
