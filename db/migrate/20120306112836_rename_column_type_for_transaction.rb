class RenameColumnTypeForTransaction < ActiveRecord::Migration
  def up
    rename_column :transactions, :type_id, :transaction_type_id
  end

  def down
    rename_column :transactions, :transaction_type_id, :type_id
  end
end
