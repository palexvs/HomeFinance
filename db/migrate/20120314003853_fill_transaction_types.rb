class FillTransactionTypes < ActiveRecord::Migration
  def up
    ["outlay", "income", "transfer"].each do |type_name|
      types = TransactionType.new(:name => type_name)
      types.save
    end
  end

  def down
  end
end
