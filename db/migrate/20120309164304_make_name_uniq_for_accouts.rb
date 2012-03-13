class MakeNameUniqForAccouts < ActiveRecord::Migration
  def up
    add_index :accounts, :name, :unique => true
  end

  def down
    remove_index :accounts, :name
  end
end
