class RenameAmountColumnInTransactions < ActiveRecord::Migration
  def change
    rename_column :transactions, :amount, :amount_cents
    rename_column :transactions, :trans_amount, :trans_amount_cents
  end
end
