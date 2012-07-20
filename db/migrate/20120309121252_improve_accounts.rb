class ImproveAccounts < ActiveRecord::Migration
  def up
    change_column :accounts, :currency, :string, :limit => 3, :null => false
    add_column :transactions, :account_id, :integer, :null => false, :default => 1
    add_index  :transactions, :account_id
  end

  def down
    remove_column :transactions, :account_id
    change_column :accounts, :currency, :string, :limit => false
  end
end
