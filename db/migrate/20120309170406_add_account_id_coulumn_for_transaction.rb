class AddAccountIdCoulumnForTransaction < ActiveRecord::Migration
  def up
    change_table :transactions do |t|
      t.references :account
    end
  end

  def down
    remove_column :transactions, :account_id
  end
end
