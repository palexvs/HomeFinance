class CreateTransactionTypes < ActiveRecord::Migration
  def change
    create_table :transaction_types do |t|
      t.string :type, :null => false
      t.string :description

      t.timestamps
    end
    add_column :transactions, :type_id, :integer, :default => 1, :null => false
    add_index :transactions, :type_id
  end
end
