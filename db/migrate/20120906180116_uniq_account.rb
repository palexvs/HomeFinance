class UniqAccount < ActiveRecord::Migration
  def change

    Account.select([:name, :currency, :user_id]).having("count(*) > 1").group(:name, :currency, :user_id).each do |ag|
      Account.where(name: ag.name, currency: ag.currency, user_id: ag.user_id).each_with_index do |a,index|
        a.update_attributes!(name: "#{a.name}_#{index}")
      end
    end

    add_index :accounts, [:name, :currency, :user_id], :unique => true
  end
end
