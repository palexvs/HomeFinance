class MoveAccountStateFromTransactionToAccount < ActiveRecord::Migration
  def up
    remove_column :transactions, :account_state
    add_column :accounts, :balance, :integer, :default => 0
    Transaction.includes(:transaction_type).all.each do |t|
      Account.update_all(["balance = balance + ? ", ((t.transaction_type.name == "outlay") ? t.amount*(-1) : t.amount)], ["id = ?", t.account_id])
    end
    change_column :accounts, :balance, :integer, :null => false, :default => nil
  end

  def down
    add_column :transactions, :account_state, :integer
    remove_column :accounts, :balance, :integer
  end
end
