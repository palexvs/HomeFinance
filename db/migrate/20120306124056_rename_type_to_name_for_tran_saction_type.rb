class RenameTypeToNameForTranSactionType < ActiveRecord::Migration
  def up
    rename_column :transaction_types, :type, :name
  end

  def down
    rename_column :transaction_types, :name, :type
  end
end
