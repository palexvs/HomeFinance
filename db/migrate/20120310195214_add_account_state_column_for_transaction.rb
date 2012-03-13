class AddAccountStateColumnForTransaction < ActiveRecord::Migration
  def up
    add_column :transactions, :account_state, :integer
    account_state = 0
    Transaction.includes(:transaction_type).order("date asc,id asc").all.each do |t|
      if(t.transaction_type.name == "outlay")
        account_state = account_state - t.amount
      else
        account_state = account_state + t.amount
      end
      t.update_attributes!(:account_state => account_state)
    end
    change_column :transactions, :account_state, :integer, :null => false
  end

  def down
    remove_column :transactions, :account_state
  end
end
