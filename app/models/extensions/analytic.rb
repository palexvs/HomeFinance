module Analytic
  
  def amount_by_day(start)
    orders = where(date: start..Date.today)
    orders = orders.where(transaction_type_id: (Transaction::TYPES.index('outlay') + 1))
    orders = orders.group(:date, :category_id)
    orders = orders.select("date, category_id, sum(amount_cents) as total_amount")
    orders.each_with_object( Hash.new{|hp,kp| hp[kp] = Hash.new{|h,k| h[k] = 0 } } ) do |r, h|
      h[r.category_id][r.date] = r.total_amount.to_i / 100 
    end
  end  

  def amount_by_category(start = 4.weeks.ago)
    orders = where(date: start..Date.today)
    orders = orders.where(transaction_type_id: 1)
    # orders = orders.where("category_id IS NOT NULL")
    orders = orders.group(:category_id)
    orders = orders.select("category_id, sum(amount_cents) as total_amount")
    orders = orders.with_category
    orders = orders.order("total_amount DESC")
    orders.each_with_object({}) { |r, h| h[r.category_id] = r.total_amount.to_i / 100 }
  end   
  
end