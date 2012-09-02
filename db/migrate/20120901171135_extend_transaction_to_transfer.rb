class ExtendTransactionToTransfer < ActiveRecord::Migration
  def change
    add_column :transactions, :trans_account_id, :integer
    add_column :transactions, :trans_amount, :integer

    add_index :transactions, :trans_account_id
  end
end
