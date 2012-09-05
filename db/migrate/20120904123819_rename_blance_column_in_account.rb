class RenameBlanceColumnInAccount < ActiveRecord::Migration
  def change
    rename_column :accounts, :balance, :balance_cents
  end
end
