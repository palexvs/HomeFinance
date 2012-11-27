module Analytic
  
  def chart_data(start = 4.weeks.ago)
    total_amount = amount_by_day(start)
    food_amount = where(category_id: 1).amount_by_day(start)
    {
      sum: (start.to_date..Date.today).map { |date| total_amount[date] || 0 },
      food: (start.to_date..Date.today).map { |date| food_amount[date] || 0 },
    }
  end

  def amount_by_day(start)
    orders = where(date: start..Date.today)
    orders = orders.where(transaction_type_id: 1)
    orders = orders.group(:date)
    orders = orders.select("date, sum(amount_cents) as total_amount")
    orders.each_with_object({}) do |order, amount|
      amount[order.date] = order.total_amount.to_i / 100 
    end
  end  

  def amount_by_category(start = 4.weeks.ago)
    orders = where(date: start..Date.today)
    orders = orders.where(transaction_type_id: 1)
    orders = orders.where("category_id IS NOT NULL")
    orders = orders.group(:category_id)
    orders = orders.select("category_id ,sum(amount_cents) as total_amount")
    orders = orders.with_category
    orders.map {|v| [v.category_name, v.total_amount.to_i / 100 ]}
  end   
  
end