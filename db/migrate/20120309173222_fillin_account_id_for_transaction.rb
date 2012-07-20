class FillinAccountIdForTransaction < ActiveRecord::Migration
  def up
    Transaction.all.each do |t|
      t.update_attributes!(:account_id => 1)
    end
    change_column :transactions, :account_id, :integer, :default => nil, :null => false
    change_column :transactions, :transaction_type_id, :integer, :default => nil

    # add_index :transactions, :account_id
  end

  def down
    change_column :transactions, :account_id, :integer, :null => true
    change_column :transactions, :transaction_type_id, :integer, :default => 1

    #remove_index :transaction, :account_id

    Transaction.all.each do |t|
      t.update_attributes!(:account_id => nil)
    end
  end
end
