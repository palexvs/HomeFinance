class SetRightDefaultValues < ActiveRecord::Migration
  def up
    remove_index :accounts, :name
    change_column :accounts, :balance_cents, :integer, :limit => 8, :default => 0, :null => false
#    add_column :accounts, :start_balance_cents, :integer, :limit => 8, :default => 0, :null => false
    change_column :accounts, :user_id, :integer, :null => false

    change_column :transactions, :amount_cents, :integer, :limit => 8, :default => 0, :null => false
    change_column :transactions, :trans_amount_cents, :integer, :limit => 8, :default => 0, :null => false
    change_column_default(:transactions, :account_id, nil)
    change_column :transactions, :date, :date, :null => false

    Transaction.update_all "user_id = 0", "user_id IS NULL"
    change_column :transactions, :user_id, :integer, :null => false

    change_column :users, :email, :string, :null => false
    change_column :users, :password_digest, :string, :null => false

    add_index :transaction_types, :name, :unique => true
  end

  def down
  end
end
