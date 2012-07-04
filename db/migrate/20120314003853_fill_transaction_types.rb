class FillTransactionTypes < ActiveRecord::Migration
  def up
    ["outlay", "income", "transfer"].each do |type_name|
      types = TransactionType.create(:name => type_name)
      types.save
    end
  end

  def down
    TransactionType.delete_all
  end
end
